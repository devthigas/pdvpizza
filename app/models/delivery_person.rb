class DeliveryPerson < ApplicationRecord
  has_many :orders, dependent: :restrict_with_error

  validates :name, presence: true
  validates :phone, presence: true

  scope :active, -> { where(active: true) }
end
