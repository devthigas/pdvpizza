class CreateStockMovements < ActiveRecord::Migration[8.1]
  def change
    create_table :stock_movements do |t|
      t.references :product, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :movement_type, null: false
      t.decimal :quantity, precision: 10, scale: 3, null: false
      t.decimal :previous_stock, precision: 10, scale: 3, null: false
      t.decimal :current_stock, precision: 10, scale: 3, null: false
      t.string :reference
      t.text :notes

      t.timestamps
    end
  end
end
