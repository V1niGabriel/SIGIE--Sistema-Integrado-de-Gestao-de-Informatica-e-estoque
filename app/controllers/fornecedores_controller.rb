class FornecedoresController < ApplicationController
  before_action :authenticate_funcionario!
  before_action :set_fornecedor, only: %i[ show edit update destroy ]

  # GET /fornecedores or /fornecedores.json
  def index
    @fornecedores = Fornecedor.all
  end

  # GET /fornecedores/1 or /fornecedores/1.json
  def show
  end

  # GET /fornecedores/new
  def new
    @fornecedor = Fornecedor.new
  end

  # GET /fornecedores/1/edit
  def edit
  end

  # POST /fornecedores or /fornecedores.json
  def create
    @fornecedor = Fornecedor.new(fornecedor_params)

    respond_to do |format|
      if @fornecedor.save
        format.html { redirect_to @fornecedor, notice: "Fornecedor was successfully created." }
        format.json { render :show, status: :created, location: @fornecedor }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @fornecedor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fornecedores/1 or /fornecedores/1.json
  def update
    respond_to do |format|
      if @fornecedor.update(fornecedor_params)
        format.html { redirect_to @fornecedor, notice: "Fornecedor was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @fornecedor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @fornecedor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fornecedores/1 or /fornecedores/1.json
  def destroy
    @fornecedor.destroy!

    respond_to do |format|
      format.html { redirect_to fornecedores_path, notice: "Fornecedor was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fornecedor
      @fornecedor = Fornecedor.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def fornecedor_params
      params.expect(fornecedor: [ :nome, :cnpj, :telefone, :email ])
    end
end
