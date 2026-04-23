class FabricantesController < ApplicationController
  before_action :set_fabricante, only: %i[ show edit update destroy ]

  # GET /fabricantes or /fabricantes.json
  def index
    @fabricantes = Fabricante.all
  end

  # GET /fabricantes/1 or /fabricantes/1.json
  def show
  end

  # GET /fabricantes/new
  def new
    @fabricante = Fabricante.new
  end

  # GET /fabricantes/1/edit
  def edit
  end

  # POST /fabricantes or /fabricantes.json
  def create
    @fabricante = Fabricante.new(fabricante_params)

    respond_to do |format|
      if @fabricante.save
        format.html { redirect_to @fabricante, notice: "Fabricante was successfully created." }
        format.json { render :show, status: :created, location: @fabricante }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @fabricante.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fabricantes/1 or /fabricantes/1.json
  def update
    respond_to do |format|
      if @fabricante.update(fabricante_params)
        format.html { redirect_to @fabricante, notice: "Fabricante was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @fabricante }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @fabricante.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fabricantes/1 or /fabricantes/1.json
  def destroy
    @fabricante.destroy!

    respond_to do |format|
      format.html { redirect_to fabricantes_path, notice: "Fabricante was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fabricante
      @fabricante = Fabricante.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def fabricante_params
      params.expect(fabricante: [ :nome_marca ])
    end
end
