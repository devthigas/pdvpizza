class DiningTable < ApplicationRecord
  has_many :orders, dependent: :restrict_with_error

  enum :status, { available: 0, occupied: 1, reserved: 2 }

  validates :number, presence: true, uniqueness: true, numericality: { greater_than: 0 }
  validates :seats, presence: true, numericality: { greater_than: 0 }
end
