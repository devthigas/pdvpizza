class Flavor < ApplicationRecord
  has_many :order_item_flavors, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }
end
