class OrdersController < ApplicationController
  before_action :ensure_open_cash_register
  before_action :set_order, only: [:show, :edit, :update, :destroy, :send_to_kitchen, :mark_ready, :start_delivery, :complete, :cancel]

  def index
    @orders = Order.includes(:customer, :dining_table).all.order(created_at: :desc)
  end

  def show
  end

  def new
    # Buscar ou criar um pedido rascunho (pending) para o usuário no caixa atual
    @order = Order.find_or_create_by!(
      user: Current.session.user,
      cash_register: @active_cash_register,
      status: :pending
    )
    redirect_to edit_order_path(@order)
  end

  def edit
    @categories = Category.ordered.includes(:products)
    # Sabores e adicionais ativos para a montagem da pizza
    @flavors = Flavor.active.order(:name)
    @additionals = Additional.active.order(:name)
    @customers = Customer.all.limit(10)
    @dining_tables = DiningTable.available.or(DiningTable.where(id: @order.dining_table_id))
    @delivery_people = DeliveryPerson.active

    @order_items = @order.order_items.includes(:product, :product_size, :flavors, :additionals)
  end

  def update
    if @order.update(order_params)
      # Se for alterado o cliente ou mesa ou delivery_fee, recalcula e atualiza via Hotwire
      @order.recalculate_totals!
      respond_to do |format|
        format.html { redirect_to edit_order_path(@order), notice: "Pedido atualizado." }
        format.turbo_stream
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # PATCH /orders/:id/send_to_kitchen
  def send_to_kitchen
    if @order.order_items.any?
      @order.send_to_kitchen!
      redirect_to orders_path, notice: "Pedido enviado para a cozinha com sucesso!"
    else
      redirect_to edit_order_path(@order), alert: "Não é possível enviar um pedido sem itens para a cozinha."
    end
  end

  # PATCH /orders/:id/mark_ready
  def mark_ready
    @order.mark_ready!
    redirect_to kitchen_path, notice: "Pedido marcado como pronto!"
  end

  # PATCH /orders/:id/start_delivery
  def start_delivery
    delivery_person = DeliveryPerson.find(params[:delivery_person_id])
    @order.start_delivery!(delivery_person)
    redirect_to orders_path, notice: "Entrega iniciada com entregador #{delivery_person.name}."
  end

  # PATCH /orders/:id/complete
  def complete
    begin
      @order.complete!
      redirect_to order_path(@order), notice: "Venda finalizada com sucesso! Recibo gerado."
    rescue => e
      redirect_to edit_order_path(@order), alert: "Erro ao finalizar venda: #{e.message}"
    end
  end

  # PATCH /orders/:id/cancel
  def cancel
    @order.cancel!
    redirect_to orders_path, notice: "Pedido cancelado com sucesso."
  end

  def destroy
    # Se for rascunho, exclui
    if @order.pending?
      @order.destroy
      redirect_to root_path, notice: "Rascunho de pedido descartado."
    else
      redirect_to orders_path, alert: "Apenas rascunhos podem ser excluídos."
    end
  end

  private

  def ensure_open_cash_register
    @active_cash_register = CashRegister.find_by(user: Current.session.user, status: :open)
    if @active_cash_register.nil?
      redirect_to cash_registers_path, alert: "Você precisa abrir o caixa antes de operar o PDV!"
    end
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:customer_id, :dining_table_id, :order_type, :delivery_fee, :discount, :delivery_address, :notes, :estimated_delivery_at)
  end
end
