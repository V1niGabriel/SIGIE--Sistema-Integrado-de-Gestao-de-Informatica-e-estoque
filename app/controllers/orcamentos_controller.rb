class OrcamentosController < ApplicationController
  before_action :authenticate_funcionario!
  before_action :set_orcamento, only: %i[ show edit update destroy ]
  before_action :load_collections, only: %i[ new edit create update ]

  def index
    @orcamentos = Orcamento.includes(:cliente, :funcionario).order(data_orcamento: :desc)
  end

  def show
    @itens_orcamento = @orcamento.itens_orcamento.includes(:item)
    @total = @itens_orcamento.sum { |io| io.quantidade * io.preco_unitario }
  end

  def new
    @orcamento = Orcamento.new(funcionario_id: current_funcionario.id, data_validade: Date.today + 3)
    @orcamento.itens_orcamento.build
  end

  def edit
  end

  def create
    @orcamento = Orcamento.new(orcamento_params)
    @orcamento.data_orcamento = Time.current

    respond_to do |format|
      if @orcamento.save
        format.html { redirect_to @orcamento, notice: "Orçamento registrado com sucesso." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @orcamento.update(orcamento_params)
        format.html { redirect_to @orcamento, notice: "Orçamento atualizado com sucesso.", status: :see_other }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @orcamento.destroy!
    respond_to do |format|
      format.html { redirect_to orcamentos_path, notice: "Orçamento excluído.", status: :see_other }
    end
  end

  def por_cliente
    orcamentos = Orcamento.where(cliente_id: params[:cliente_id])
                          .includes(itens_orcamento: :item)
                          .order(data_orcamento: :desc)

    render json: orcamentos.map { |o|
      {
        id: o.id,
        cliente_id: o.cliente_id,
        data: o.data_orcamento.strftime("%d/%m/%Y"),
        data_validade: o.data_validade.strftime("%d/%m/%Y"),
        itens: o.itens_orcamento.map { |io|
          {
            item_id: io.item_id,
            descricao: io.item.descricao,
            quantidade: io.quantidade,
            preco_unitario: io.preco_unitario.to_f
          }
        }
      }
    }
  end

  private

  def set_orcamento
    @orcamento = Orcamento.find(params[:id])
  end

  def load_collections
    @clientes = Cliente.order(:nome_razao_social)
    @funcionarios = Funcionario.order(:nome)
    @itens = Item.order(:descricao)
  end

  def orcamento_params
    params.require(:orcamento).permit(
      :cliente_id, :funcionario_id, :data_validade,
      itens_orcamento_attributes: [ :id, :item_id, :quantidade, :preco_unitario, :_destroy ]
    )
  end
end
