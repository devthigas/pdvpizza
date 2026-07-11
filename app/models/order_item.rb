class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  belongs_to :product_size, optional: true
  has_many :order_item_flavors, dependent: :destroy
  has_many :flavors, through: :order_item_flavors
  has_many :order_item_additionals, dependent: :destroy
  has_many :additionals, through: :order_item_additionals

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :validate_flavors_count

  before_save :calculate_total
  after_save :recalculate_order_totals
  after_destroy :recalculate_order_totals

  def additionals_total
    order_item_additionals.sum(:price)
  end

  def description
    if product.is_pizza? && product_size
      flavor_names = flavors.pluck(:name).join(" / ")
      "#{product.name} #{product_size.size_name} - #{flavor_names}"
    else
      product.name
    end
  end

  private

  def calculate_total
    additionals_sum = order_item_additionals.sum(:price)
    self.total = (quantity * unit_price) + additionals_sum - discount
  end

  def recalculate_order_totals
    order.recalculate_totals! if order.persisted?
  end

  def validate_flavors_count
    return unless product&.is_pizza? && product_size

    if flavors.size > product_size.max_flavors
      errors.add(:flavors, "máximo de #{product_size.max_flavors} sabor(es) para este tamanho")
    end

    if flavors.empty?
      errors.add(:flavors, "selecione pelo menos um sabor")
    end
  end
end
