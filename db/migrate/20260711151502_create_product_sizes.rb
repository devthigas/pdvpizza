class CreateProductSizes < ActiveRecord::Migration[8.1]
  def change
    create_table :product_sizes do |t|
      t.references :product, null: false, foreign_key: true
      t.string :size_name, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :max_flavors, default: 1, null: false

      t.timestamps
    end
  end
end
