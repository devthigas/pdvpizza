class Order < ApplicationRecord
  belongs_to :user
  belongs_to :customer, optional: true
  belongs_to :cash_register
  belongs_to :dining_table, optional: true
  belongs_to :delivery_person, optional: true
  has_many :order_items, dependent: :destroy
  has_many :payments, dependent: :destroy

  enum :order_type, { balcao: 0, mesa: 1, delivery: 2 }
  enum :status, { pending: 0, in_kitchen: 1, ready: 2, delivering: 3, completed: 4, cancelled: 5 }

  validates :number, presence: true, uniqueness: true
  validates :dining_table, presence: true, if: :mesa?
  validates :delivery_address, presence: true, if: :delivery?
  validate :cash_register_must_be_open, on: :create

  before_validation :generate_number, on: :create

  scope :today, -> { where(created_at: Date.current.all_day) }

  def recalculate_totals!
    self.subtotal = order_items.sum(:total)
    self.total = subtotal + delivery_fee - discount
    save!
  end

  def send_to_kitchen!
    update!(status: :in_kitchen)
    dining_table&.occupied! if mesa?
  end

  def mark_ready!
    update!(status: :ready)
  end

  def start_delivery!(delivery_person)
    update!(
      status: :delivering,
      delivery_person: delivery_person
    )
  end

  def complete!
    transaction do
      validate_payments!
      deduct_stock!
      update!(status: :completed)
      dining_table&.available! if mesa?
      Fiscal::Emitter.emit(self)
    end
  end

  def cancel!
    transaction do
      restore_stock! if in_kitchen? || ready? || delivering?
      update!(status: :cancelled)
      dining_table&.available! if mesa?
    end
  end

  def total_paid
    payments.sum(:amount)
  end

  def remaining_amount
    total - total_paid
  end

  def fully_paid?
    total_paid >= total
  end

  private

  def generate_number
    today = Date.current.strftime("%Y%m%d")
    last_order = Order.where("number LIKE ?", "PED-#{today}-%").order(:number).last
    sequence = if last_order
      last_order.number.split("-").last.to_i + 1
    else
      1
    end
    self.number = "PED-#{today}-#{sequence.to_s.rjust(4, '0')}"
  end

  def cash_register_must_be_open
    if cash_register && !cash_register.open?
      errors.add(:cash_register, "deve estar aberto")
    end
  end

  def validate_payments!
    unless fully_paid?
      raise ActiveRecord::RecordInvalid.new(self), "Pagamento insuficiente. Faltam R$ #{'%.2f' % remaining_amount}"
    end
  end

  def deduct_stock!
    order_items.includes(:product).each do |item|
      product = item.product
      next if product.is_pizza? # Pizzas não descontam estoque diretamente

      StockMovement.create!(
        product: product,
        user: user,
        movement_type: :venda,
        quantity: -item.quantity,
        previous_stock: product.current_stock,
        current_stock: product.current_stock - item.quantity,
        reference: "Pedido #{number}"
      )
    end
  end

  def restore_stock!
    order_items.includes(:product).each do |item|
      product = item.product
      next if product.is_pizza?

      StockMovement.create!(
        product: product,
        user: user,
        movement_type: :ajuste,
        quantity: item.quantity,
        previous_stock: product.current_stock,
        current_stock: product.current_stock + item.quantity,
        reference: "Cancelamento Pedido #{number}"
      )
    end
  end
end
