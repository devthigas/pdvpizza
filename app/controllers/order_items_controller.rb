class OrderItemsController < ApplicationController
  before_action :set_order

  # POST /orders/:order_id/order_items
  def create
    @product = Product.find(params[:product_id])
    
    if @product.is_pizza?
      # Fluxo de montagem de pizza
      size = ProductSize.find(params[:product_size_id])
      unit_price = size.price
      
      @order_item = @order.order_items.new(
        product: @product,
        product_size: size,
        quantity: params[:quantity].presence || 1,
        unit_price: unit_price,
        observation: params[:observation]
      )

      # Sabores (máximo validado no model)
      flavor_ids = params[:flavor_ids] || []
      flavor_ids.reject!(&:blank?)
      flavor_ids.each do |fid|
        @order_item.order_item_flavors.new(flavor_id: fid)
      end

      # Adicionais
      additional_ids = params[:additional_ids] || []
      additional_ids.reject!(&:blank?)
      additional_ids.each do |aid|
        add = Additional.find(aid)
        @order_item.order_item_additionals.new(additional: add, price: add.price)
      end
    else
      # Bebidas ou produtos comuns
      quantity = (params[:quantity].presence || 1).to_f
      unit_price = @product.base_price

      @order_item = @order.order_items.new(
        product: @product,
        quantity: quantity,
        unit_price: unit_price,
        observation: params[:observation]
      )
    end

    respond_to do |format|
      if @order_item.save
        @order.recalculate_totals!
        format.html { redirect_to edit_order_path(@order), notice: "Item adicionado com sucesso!" }
        format.turbo_stream
      else
        format.html { redirect_to edit_order_path(@order), alert: @order_item.errors.full_messages.to_sentence }
      end
    end
  end

  # PATCH/PUT /orders/:order_id/order_items/:id
  def update
    @order_item = @order.order_items.find(params[:id])
    
    respond_to do |format|
      if @order_item.update(order_item_params)
        @order.recalculate_totals!
        format.html { redirect_to edit_order_path(@order), notice: "Item atualizado." }
        format.turbo_stream
      else
        format.html { redirect_to edit_order_path(@order), alert: @order_item.errors.full_messages.to_sentence }
      end
    end
  end

  # DELETE /orders/:order_id/order_items/:id
  def destroy
    @order_item = @order.order_items.find(params[:id])
    @order_item.destroy
    @order.recalculate_totals!

    respond_to do |format|
      format.html { redirect_to edit_order_path(@order), notice: "Item removido." }
      format.turbo_stream
    end
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def order_item_params
    params.require(:order_item).permit(:quantity, :discount, :observation)
  end
end
