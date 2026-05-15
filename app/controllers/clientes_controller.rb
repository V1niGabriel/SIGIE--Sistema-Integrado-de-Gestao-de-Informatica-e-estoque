class ClientesController < ApplicationController
  before_action :authenticate_funcionario!
  before_action :set_cliente, only: %i[ show edit update destroy ]

  # Bloqueia a página de listagem se não puder visualizar
  before_action -> { verificar_permissao(:visualizar_clientes) }, only: [:index, :show]
  
  # Bloqueia a criação se não puder criar
  before_action -> { verificar_permissao(:criar_clientes) }, only: [:new, :create]
  
  # Bloqueia a edição se não puder editar
  before_action -> { verificar_permissao(:editar_clientes) }, only: [:edit, :update]
  
  # Bloqueia a exclusão
  before_action -> { verificar_permissao(:excluir_clientes) }, only: [:destroy]

  # GET /clientes or /clientes.json
  def index
    if params[:query].present?
      # O comando ILIKE no banco PostgreSQL faz a busca ignorando letras maiúsculas e minúsculas.
      # Os % antes e depois indicam que a palavra pode estar em qualquer lugar do texto (Busca parcial).
      termo_busca = "%#{params[:query]}%"
      @clientes = Cliente.where("nome_razao_social ILIKE :query OR cpf_cnpj ILIKE :query OR email ILIKE :query", query: termo_busca).order(:nome_razao_social)
    else
      # Se não tiver pesquisa, mostra todos em ordem alfabética
      @clientes = Cliente.order(:nome_razao_social)
    end
  end

  # GET /clientes/1 or /clientes/1.json
  def show
  end

  # GET /clientes/new
  def new
    @cliente = Cliente.new
  end

  # GET /clientes/1/edit
  def edit
  end

  # POST /clientes or /clientes.json
  def create
    @cliente = Cliente.new(cliente_params)

    respond_to do |format|
      if @cliente.save
        format.html { redirect_to @cliente, notice: "Cliente was successfully created." }
        format.json { render :show, status: :created, location: @cliente }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cliente.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clientes/1 or /clientes/1.json
  def update
    respond_to do |format|
      if @cliente.update(cliente_params)
        format.html { redirect_to @cliente, notice: "Cliente was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @cliente }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cliente.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clientes/1 or /clientes/1.json
  def destroy
    @cliente.destroy!

    respond_to do |format|
      format.html { redirect_to clientes_path, notice: "Cliente was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cliente
      @cliente = Cliente.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def cliente_params
      params.expect(cliente: [ :nome_razao_social, :cpf_cnpj, :telefone, :email ])
    end
end
