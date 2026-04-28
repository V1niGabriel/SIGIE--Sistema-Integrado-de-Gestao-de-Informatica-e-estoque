class VendasController < ApplicationController
  before_action :authenticate_funcionario!
  before_action :set_venda, only: %i[ show edit update destroy ]
  before_action :load_collections, only: %i[ new edit create update ]

  def index
    @vendas = Venda.includes(:cliente, :funcionario).order(data_venda: :desc)
  end

  def show
    @itens_venda = @venda.itens_venda.includes(:item)
    @total = @itens_venda.sum { |iv| iv.quantidade * iv.preco_unitario }
  end

  def new
    @venda = Venda.new(funcionario_id: current_funcionario.id)
    @venda.itens_venda.build
  end

  def edit
  end

  def create
    @venda = Venda.new(venda_params)
    @venda.data_venda = Time.current

    saved = ApplicationRecord.transaction do
      @venda.save! && registrar_movimentacoes_saida(@venda.itens_venda, "item vendido")
    rescue ActiveRecord::RecordInvalid
      false
    end

    if saved
      redirect_to @venda, notice: "Venda registrada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    old_qtds = @venda.itens_venda.each_with_object({}) { |iv, h| h[iv.item_id] = iv.quantidade }

    updated = ApplicationRecord.transaction do
      @venda.update!(venda_params) && registrar_movimentacoes_correcao(old_qtds)
    rescue ActiveRecord::RecordInvalid
      false
    end

    if updated
      redirect_to @venda, notice: "Venda atualizada com sucesso.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @venda.destroy!
    respond_to do |format|
      format.html { redirect_to vendas_path, notice: "Venda excluída.", status: :see_other }
    end
  end

  private

  def set_venda
    @venda = Venda.find(params.expect(:id))
  end

  def load_collections
    @clientes = Cliente.order(:nome_razao_social)
    @funcionarios = Funcionario.order(:nome)
    @itens = Item.order(:descricao)
  end

  def venda_params
    params.require(:venda).permit(
      :cliente_id, :funcionario_id, :status_pagamento,
      itens_venda_attributes: [ :id, :item_id, :quantidade, :preco_unitario, :_destroy ]
    )
  end

  def registrar_movimentacoes_saida(itens, motivo)
    itens.each do |iv|
      MovimentacaoEstoque.create!(
        item_id:        iv.item_id,
        venda_id:       @venda.id,
        funcionario_id: current_funcionario.id,
        quantidade:     iv.quantidade,
        tipo:           :saida,
        motivo:         motivo,
        data:           Time.current
      )
      iv.item.decrement!(:quantidade_estoque, iv.quantidade)
    end
    true
  end

  def registrar_movimentacoes_correcao(old_qtds)
    new_qtds = @venda.itens_venda.reload.each_with_object({}) { |iv, h| h[iv.item_id] = iv.quantidade }

    (old_qtds.keys | new_qtds.keys).each do |item_id|
      diff = (new_qtds[item_id] || 0) - (old_qtds[item_id] || 0)
      next if diff == 0

      MovimentacaoEstoque.create!(
        item_id:        item_id,
        venda_id:       @venda.id,
        funcionario_id: current_funcionario.id,
        quantidade:     diff.abs,
        tipo:           diff > 0 ? :saida : :entrada,
        motivo:         "correção dos itens da venda",
        data:           Time.current
      )
      item = Item.find(item_id)
      diff > 0 ? item.decrement!(:quantidade_estoque, diff) : item.increment!(:quantidade_estoque, diff.abs)
    end
    true
  end
end
