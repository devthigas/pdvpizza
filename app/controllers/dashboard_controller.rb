class DashboardController < ApplicationController
  def index
    @orders_today = Order.today
    @total_sales_today = Order.completed.today.sum(:total)
    @orders_count_today = @orders_today.count
    @pending_orders = Order.where(status: [:pending, :in_kitchen, :ready, :delivering]).order(created_at: :desc)
    @low_stock_products = Product.low_stock.limit(5)

    # Ranking de sabores mais vendidos hoje
    @top_flavors = Flavor.joins(order_item_flavors: { order_item: :order })
                         .where(orders: { created_at: Date.current.all_day, status: :completed })
                         .group(:id, :name)
                         .select("flavors.name, count(order_item_flavors.id) as sales_count")
                         .order("sales_count DESC")
                         .limit(5)
  end
end
