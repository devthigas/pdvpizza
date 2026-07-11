class Product < ApplicationRecord
  belongs_to :category
  has_many :product_sizes, dependent: :destroy
  has_many :order_items, dependent: :restrict_with_error
  has_many :stock_movements, dependent: :restrict_with_error

  validates :name, presence: true
  validates :description, presence: true
  validates :barcode, uniqueness: true, allow_blank: true
  validates :sku, uniqueness: true, allow_blank: true
  validates :unit, presence: true
  validates :base_price, presence: true, numericality: { greater_than_or_equal_to: 0 }, unless: :is_pizza?
  validate :sale_price_or_sizes, if: :is_pizza?

  scope :active, -> { where(active: true) }
  scope :pizzas, -> { where(is_pizza: true) }
  scope :non_pizzas, -> { where(is_pizza: false) }
  scope :low_stock, -> { where("current_stock <= min_stock") }

  accepts_nested_attributes_for :product_sizes, allow_destroy: true, reject_if: :all_blank

  def display_price
    if is_pizza?
      prices = product_sizes.pluck(:price).compact
      return "A partir de R$ #{'%.2f' % prices.min}" if prices.any?

      "Sem preço definido"
    else
      "R$ #{'%.2f' % base_price}"
    end
  end

  private

  def sale_price_or_sizes
    if product_sizes.empty? || product_sizes.all? { |ps| ps.marked_for_destruction? }
      errors.add(:product_sizes, "deve ter pelo menos um tamanho para pizzas")
    end
  end
end
