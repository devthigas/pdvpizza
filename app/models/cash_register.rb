class CashRegister < ApplicationRecord
  belongs_to :user
  has_many :orders, dependent: :restrict_with_error

  enum :status, { open: 0, closed: 1 }

  validates :opening_balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :opened_at, presence: true
  validate :only_one_open_per_user, on: :create

  before_validation :set_opened_at, on: :create

  def close!(closing_balance_value)
    update!(
      closing_balance: closing_balance_value,
      status: :closed,
      closed_at: Time.current
    )
  end

  def total_sales
    orders.completed.sum(:total)
  end

  def balance_difference
    return nil unless closed?

    closing_balance - opening_balance - total_sales
  end

  private

  def set_opened_at
    self.opened_at ||= Time.current
  end

  def only_one_open_per_user
    if user && CashRegister.where(user: user, status: :open).exists?
      errors.add(:base, "Já existe um caixa aberto para este usuário")
    end
  end
end
