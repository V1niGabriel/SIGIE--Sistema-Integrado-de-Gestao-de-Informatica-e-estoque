class ItensController < ApplicationController
  before_action :authenticate_funcionario!
  before_action :set_item, only: %i[ show edit update destroy ]

  # GET /itens or /itens.json
  def index
    #@itens = Item.all
    # O .includes puxa os dados relacionados de uma só vez, deixando a tela super rápida
    @itens = Item.includes(:categoria, :fabricante, :fornecedor).all
  end

  # GET /itens/1 or /itens/1.json
  def show
  end

  # GET /itens/new
  def new
    @item = Item.new
  end

  # GET /itens/1/edit
  def edit
  end

  # POST /itens or /itens.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: "Item was successfully created." }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /itens/1 or /itens/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: "Item was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /itens/1 or /itens/1.json
  def destroy
    @item.destroy!

    respond_to do |format|
      format.html { redirect_to itens_path, notice: "Item was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.expect(item: [ :fornecedor_id, :categoria_id, :fabricante_id, :descricao, :quantidade_estoque, :preco_custo, :preco_venda, :ncm ])
    end
end
