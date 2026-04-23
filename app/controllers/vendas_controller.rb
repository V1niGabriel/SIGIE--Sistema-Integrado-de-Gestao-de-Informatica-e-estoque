class VendasController < ApplicationController
  before_action :set_venda, only: %i[ show edit update destroy ]

  # GET /vendas or /vendas.json
  def index
    @vendas = Venda.all
  end

  # GET /vendas/1 or /vendas/1.json
  def show
  end

  # GET /vendas/new
  def new
    @venda = Venda.new
  end

  # GET /vendas/1/edit
  def edit
  end

  # POST /vendas or /vendas.json
  def create
    @venda = Venda.new(venda_params)

    respond_to do |format|
      if @venda.save
        format.html { redirect_to @venda, notice: "Venda was successfully created." }
        format.json { render :show, status: :created, location: @venda }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @venda.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vendas/1 or /vendas/1.json
  def update
    respond_to do |format|
      if @venda.update(venda_params)
        format.html { redirect_to @venda, notice: "Venda was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @venda }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @venda.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vendas/1 or /vendas/1.json
  def destroy
    @venda.destroy!

    respond_to do |format|
      format.html { redirect_to vendas_path, notice: "Venda was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_venda
      @venda = Venda.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def venda_params
      params.expect(venda: [ :cliente_id, :funcionario_id, :data_venda, :status_pagamento ])
    end
end
