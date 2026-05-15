class CargosController < ApplicationController
  before_action :authenticate_funcionario!
  before_action :set_cargo, only: %i[ show edit update destroy ]
  
  # Bloqueia a página de listagem se não puder visualizar
  before_action -> { verificar_permissao(:visualizar_clientes) }, only: [:index, :show]
  
  # Bloqueia a criação se não puder criar
  before_action -> { verificar_permissao(:criar_clientes) }, only: [:new, :create]
  
  # Bloqueia a edição se não puder editar
  before_action -> { verificar_permissao(:editar_clientes) }, only: [:edit, :update]
  
  # Bloqueia a exclusão
  before_action -> { verificar_permissao(:excluir_clientes) }, only: [:destroy]

  # GET /cargos or /cargos.json
  def index
    @cargos = Cargo.all
  end

  # GET /cargos/1 or /cargos/1.json
  def show
  end

  # GET /cargos/new
  def new
    @cargo = Cargo.new
  end

  # GET /cargos/1/edit
  def edit
  end

  # POST /cargos or /cargos.json
  def create
    @cargo = Cargo.new(cargo_params)

    respond_to do |format|
      if @cargo.save
        format.html { redirect_to cargos_path, notice: "Cargo criado com sucesso!" }
        format.json { render :show, status: :created, location: @cargo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cargo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cargos/1 or /cargos/1.json
  def update
    respond_to do |format|
      if @cargo.update(cargo_params)
        format.html { redirect_to cargos_path, notice: "Cargo atualizado com sucesso!", status: :see_other }
        format.json { render :show, status: :ok, location: @cargo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cargo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cargos/1 or /cargos/1.json
  def destroy
    @cargo.destroy!

    respond_to do |format|
      format.html { redirect_to cargos_path, notice: "Cargo was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cargo
      @cargo = Cargo.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    private

    def cargo_params
      params.require(:cargo).permit(
        :titulo, :descricao, :salario_base,
        
        # Permissões
        :visualizar_vendas, :criar_vendas, :editar_vendas, :excluir_vendas,
        :visualizar_orcamentos, :criar_orcamentos, :editar_orcamentos, :excluir_orcamentos,
        :visualizar_clientes, :criar_clientes, :editar_clientes, :excluir_clientes,
        :visualizar_itens, :criar_itens, :editar_itens, :excluir_itens,
        :visualizar_categorias, :criar_categorias, :editar_categorias, :excluir_categorias,
        :visualizar_fabricantes, :criar_fabricantes, :editar_fabricantes, :excluir_fabricantes,
        :visualizar_movimentacoes, :criar_movimentacoes, :editar_movimentacoes, :excluir_movimentacoes,
        :visualizar_compras, :criar_compras, :editar_compras, :excluir_compras,
        :visualizar_fornecedores, :criar_fornecedores, :editar_fornecedores, :excluir_fornecedores,
        :visualizar_funcionarios, :criar_funcionarios, :editar_funcionarios, :excluir_funcionarios,
        :visualizar_cargos, :criar_cargos, :editar_cargos, :excluir_cargos,
        :visualizar_empresa, :editar_empresa
      )
    end
end
