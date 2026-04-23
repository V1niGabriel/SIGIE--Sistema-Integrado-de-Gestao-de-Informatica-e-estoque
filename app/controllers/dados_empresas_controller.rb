class DadosEmpresasController < ApplicationController
  before_action :set_dados_empresa, only: %i[ show edit update destroy ]

  # GET /dados_empresas or /dados_empresas.json
  def index
    @dados_empresas = DadosEmpresa.all
  end

  # GET /dados_empresas/1 or /dados_empresas/1.json
  def show
  end

  # GET /dados_empresas/new
  def new
    @dados_empresa = DadosEmpresa.new
  end

  # GET /dados_empresas/1/edit
  def edit
  end

  # POST /dados_empresas or /dados_empresas.json
  def create
    @dados_empresa = DadosEmpresa.new(dados_empresa_params)

    respond_to do |format|
      if @dados_empresa.save
        format.html { redirect_to @dados_empresa, notice: "Dados empresa was successfully created." }
        format.json { render :show, status: :created, location: @dados_empresa }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @dados_empresa.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dados_empresas/1 or /dados_empresas/1.json
  def update
    respond_to do |format|
      if @dados_empresa.update(dados_empresa_params)
        format.html { redirect_to @dados_empresa, notice: "Dados empresa was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @dados_empresa }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @dados_empresa.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dados_empresas/1 or /dados_empresas/1.json
  def destroy
    @dados_empresa.destroy!

    respond_to do |format|
      format.html { redirect_to dados_empresas_path, notice: "Dados empresa was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dados_empresa
      @dados_empresa = DadosEmpresa.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def dados_empresa_params
      params.expect(dados_empresa: [ :cnpj, :razao_social, :ie, :im, :regime_tributario, :rua, :numero, :complemento, :bairro, :cidade, :estado, :cep ])
    end
end
