class OrderItemAdditional < ApplicationRecord
  belongs_to :order_item
  belongs_to :additional

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
