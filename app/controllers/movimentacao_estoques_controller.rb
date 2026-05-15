class MovimentacaoEstoquesController < ApplicationController
  before_action :authenticate_funcionario!
  before_action :set_movimentacao, only: %i[ show ]

  # Bloqueia a página de listagem se não puder visualizar
  before_action -> { verificar_permissao(:visualizar_clientes) }, only: [:index, :show]
  
  # Bloqueia a criação se não puder criar
  before_action -> { verificar_permissao(:criar_clientes) }, only: [:new, :create]

  def index
    @movimentacoes = MovimentacaoEstoque
      .includes(:item, :funcionario, :venda, :compra)
      .order(data: :desc)
  end

  def show
  end

  def new
    @movimentacao_estoque = MovimentacaoEstoque.new(data: Time.current)
    @itens = Item.order(:descricao)
    @funcionarios = Funcionario.order(:nome)
  end

  def create
    @movimentacao_estoque = MovimentacaoEstoque.new(movimentacao_params)
    @movimentacao_estoque.funcionario = current_funcionario

    unless %w[entrada_avulsa saida_avulsa].include?(@movimentacao_estoque.tipo)
      @movimentacao_estoque.errors.add(:tipo, "inválido para ajuste manual")
      render_new and return
    end

    saved = ApplicationRecord.transaction do
      @movimentacao_estoque.save! && ajustar_estoque
    rescue ActiveRecord::RecordInvalid
      false
    end

    if saved
      redirect_to movimentacao_estoques_path, notice: "Movimentação registrada com sucesso."
    else
      render_new
    end
  end

  private

  def set_movimentacao
    @movimentacao_estoque = MovimentacaoEstoque.find(params.expect(:id))
  end

  def movimentacao_params
    params.require(:movimentacao_estoque).permit(:item_id, :tipo, :quantidade, :motivo, :data)
  end

  def ajustar_estoque
    item = @movimentacao_estoque.item
    qty  = @movimentacao_estoque.quantidade
    if @movimentacao_estoque.entrada_avulsa?
      item.increment!(:quantidade_estoque, qty)
    else
      item.decrement!(:quantidade_estoque, qty)
    end
    true
  end

  def render_new
    @itens = Item.order(:descricao)
    @funcionarios = Funcionario.order(:nome)
    render :new, status: :unprocessable_entity
  end
end
