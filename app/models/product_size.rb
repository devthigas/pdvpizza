class ProductSize < ApplicationRecord
  belongs_to :product

  validates :size_name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :max_flavors, presence: true, numericality: { in: 1..2 }
end
