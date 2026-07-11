class CreateOrderItemFlavors < ActiveRecord::Migration[8.1]
  def change
    create_table :order_item_flavors do |t|
      t.references :order_item, null: false, foreign_key: true
      t.references :flavor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
