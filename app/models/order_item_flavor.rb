class OrderItemFlavor < ApplicationRecord
  belongs_to :order_item
  belongs_to :flavor

  validates :flavor_id, uniqueness: { scope: :order_item_id, message: "já foi adicionado" }
end
