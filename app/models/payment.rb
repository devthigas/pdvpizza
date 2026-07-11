class Payment < ApplicationRecord
  belongs_to :order

  enum :payment_method, { dinheiro: 0, credito: 1, debito: 2, pix: 3, outro: 4 }

  validates :amount, presence: true, numericality: { greater_than: 0 }

  after_save :recalculate_change

  private

  def recalculate_change
    if dinheiro? && order.fully_paid?
      excess = order.total_paid - order.total
      update_column(:change_amount, excess) if excess > 0
    end
  end
end
