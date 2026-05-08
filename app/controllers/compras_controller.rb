class ComprasController < ApplicationController
  before_action :authenticate_funcionario!
  before_action :set_compra, only: %i[ show edit update destroy ]
  before_action :load_collections, only: %i[ new edit create update ]

  def index
    @compras = Compra.includes(:fornecedor, itens_compra: :item).order(created_at: :desc)
  end

  def show
    @itens_compra = @compra.itens_compra.includes(:item)
    @total = @itens_compra.sum { |ic| ic.quantidade * ic.preco_unitario }
  end

  def new
    @compra = Compra.new
    @compra.itens_compra.build
  end

  def edit
  end

  def create
    @compra = Compra.new(compra_params)
    @compra.valor_total = calcular_total(@compra.itens_compra)

    saved = ApplicationRecord.transaction do
      @compra.save! && registrar_movimentacoes_entrada(@compra.itens_compra)
    rescue ActiveRecord::RecordInvalid
      false
    end

    if saved
      redirect_to @compra, notice: "Compra registrada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    old_qtds = @compra.itens_compra.each_with_object({}) { |ic, h| h[ic.item_id] = ic.quantidade }

    updated = ApplicationRecord.transaction do
      @compra.assign_attributes(compra_params)
      @compra.valor_total = calcular_total(@compra.itens_compra.reject(&:marked_for_destruction?))
      @compra.save! && registrar_movimentacoes_correcao(old_qtds)
    rescue ActiveRecord::RecordInvalid
      false
    end

    if updated
      redirect_to @compra, notice: "Compra atualizada com sucesso.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @compra.destroy!
    redirect_to compras_path, notice: "Compra excluída.", status: :see_other
  end

  private

  def set_compra
    @compra = Compra.find(params.expect(:id))
  end

  def load_collections
    @fornecedores = Fornecedor.order(:nome)
    @itens = Item.order(:descricao)
  end

  def compra_params
    params.require(:compra).permit(
      :fornecedor_id, :data_vencimento, :status,
      itens_compra_attributes: [ :id, :item_id, :quantidade, :preco_unitario, :_destroy ]
    )
  end

  def calcular_total(itens)
    itens.sum { |ic| (ic.quantidade || 0) * (ic.preco_unitario || 0) }
  end

  def registrar_movimentacoes_entrada(itens)
    itens.each do |ic|
      ic.item.increment!(:quantidade_estoque, ic.quantidade)
      MovimentacaoEstoque.create!(
        item_id:        ic.item_id,
        compra_id:      @compra.id,
        funcionario_id: current_funcionario.id,
        quantidade:     ic.quantidade,
        tipo:           :entrada,
        motivo:         "item comprado",
        data:           Time.current
      )
    end
    true
  end

  def registrar_movimentacoes_correcao(old_qtds)
    new_qtds = @compra.itens_compra.reload.each_with_object({}) { |ic, h| h[ic.item_id] = ic.quantidade }

    (old_qtds.keys | new_qtds.keys).each do |item_id|
      diff = (new_qtds[item_id] || 0) - (old_qtds[item_id] || 0)
      next if diff == 0

      item = Item.find(item_id)
      tipo = diff > 0 ? :entrada : :saida

      MovimentacaoEstoque.create!(
        item_id:        item_id,
        compra_id:      @compra.id,
        funcionario_id: current_funcionario.id,
        quantidade:     diff.abs,
        tipo:           tipo,
        motivo:         "correção dos itens da compra",
        data:           Time.current
      )
      diff > 0 ? item.increment!(:quantidade_estoque, diff) : item.decrement!(:quantidade_estoque, diff.abs)
    end
    true
  end
end
