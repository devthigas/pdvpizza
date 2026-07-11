class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name, null: false
      t.string :description, null: false
      t.string :barcode
      t.string :sku
      t.boolean :is_pizza, default: false, null: false
      t.decimal :base_price, precision: 10, scale: 2
      t.decimal :cost_price, precision: 10, scale: 2
      t.decimal :current_stock, precision: 10, scale: 3, default: 0, null: false
      t.string :unit, null: false, default: "un"
      t.decimal :min_stock, precision: 10, scale: 3, default: 0, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :products, :barcode, unique: true
    add_index :products, :sku, unique: true
  end
end
