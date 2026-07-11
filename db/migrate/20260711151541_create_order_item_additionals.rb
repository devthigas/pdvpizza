class CreateOrderItemAdditionals < ActiveRecord::Migration[8.1]
  def change
    create_table :order_item_additionals do |t|
      t.references :order_item, null: false, foreign_key: true
      t.references :additional, null: false, foreign_key: true
      t.decimal :price, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
