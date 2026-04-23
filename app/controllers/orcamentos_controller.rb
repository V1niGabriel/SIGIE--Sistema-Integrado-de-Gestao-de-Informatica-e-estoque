class OrcamentosController < ApplicationController
  before_action :set_orcamento, only: %i[ show edit update destroy ]

  # GET /orcamentos or /orcamentos.json
  def index
    @orcamentos = Orcamento.all
  end

  # GET /orcamentos/1 or /orcamentos/1.json
  def show
  end

  # GET /orcamentos/new
  def new
    @orcamento = Orcamento.new
  end

  # GET /orcamentos/1/edit
  def edit
  end

  # POST /orcamentos or /orcamentos.json
  def create
    @orcamento = Orcamento.new(orcamento_params)

    respond_to do |format|
      if @orcamento.save
        format.html { redirect_to @orcamento, notice: "Orcamento was successfully created." }
        format.json { render :show, status: :created, location: @orcamento }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @orcamento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orcamentos/1 or /orcamentos/1.json
  def update
    respond_to do |format|
      if @orcamento.update(orcamento_params)
        format.html { redirect_to @orcamento, notice: "Orcamento was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @orcamento }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @orcamento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orcamentos/1 or /orcamentos/1.json
  def destroy
    @orcamento.destroy!

    respond_to do |format|
      format.html { redirect_to orcamentos_path, notice: "Orcamento was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_orcamento
      @orcamento = Orcamento.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def orcamento_params
      params.expect(orcamento: [ :cliente_id, :funcionario_id, :data_orcamento, :data_validade ])
    end
end
