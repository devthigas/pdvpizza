class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :cash_registers, dependent: :restrict_with_error
  has_many :orders, dependent: :restrict_with_error
  has_many :stock_movements, dependent: :restrict_with_error

  enum :role, { operador: 0, cozinha: 1, gerente: 2, admin: 3 }

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  scope :active, -> { where(active: true) }
end
