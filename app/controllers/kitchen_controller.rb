class KitchenController < ApplicationController
  # GET /kitchen
  def index
    # Exibir pedidos em preparação (in_kitchen) e prontos (ready) hoje
    @in_preparation_orders = Order.in_kitchen.order(created_at: :asc)
    @ready_orders = Order.ready.where(updated_at: 1.hour.ago..Time.current).order(updated_at: :desc)
  end
end
