class StockMovementsController < ApplicationController
  before_action :set_product

  # GET /products/:product_id/stock_movements
  def index
    @stock_movements = @product.stock_movements.includes(:user).order(created_at: :desc)
  end

  # GET /products/:product_id/stock_movements/new
  def new
    @stock_movement = @product.stock_movements.new
  end

  # POST /products/:product_id/stock_movements
  def create
    quantity = params[:stock_movement][:quantity].to_f
    movement_type = params[:stock_movement][:movement_type]
    notes = params[:stock_movement][:notes]
    
    # Determinar a quantidade com sinal correto
    # Entrada = quantidade positiva
    # Saida = quantidade negativa
    # Ajuste = define a quantidade absoluta ou diferença. Vamos usar como incremento/decremento simples:
    # se entrada, soma. Se saida ou ajuste negativo, subtrai.
    signed_quantity = if movement_type == "entrada"
      quantity.abs
    elsif movement_type == "saida"
      -quantity.abs
    else # ajuste
      # se for ajuste, podemos apenas aplicar a quantidade digitada diretamente
      quantity
    end

    previous_stock = @product.current_stock
    current_stock = previous_stock + signed_quantity

    @stock_movement = @product.stock_movements.new(
      user: Current.session.user,
      movement_type: movement_type,
      quantity: signed_quantity,
      previous_stock: previous_stock,
      current_stock: current_stock,
      notes: notes
    )

    if @stock_movement.save
      redirect_to product_stock_movements_path(@product), notice: "Movimentação de estoque registrada com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end
end
