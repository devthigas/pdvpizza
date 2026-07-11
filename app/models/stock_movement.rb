class StockMovement < ApplicationRecord
  belongs_to :product
  belongs_to :user

  enum :movement_type, { entrada: 0, saida: 1, ajuste: 2, venda: 3 }

  validates :quantity, presence: true
  validates :movement_type, presence: true
  validates :previous_stock, presence: true
  validates :current_stock, presence: true

  after_create :update_product_stock

  private

  def update_product_stock
    product.update_column(:current_stock, current_stock)
  end
end
