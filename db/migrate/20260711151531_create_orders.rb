class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :customer, foreign_key: true
      t.references :cash_register, null: false, foreign_key: true
      t.references :dining_table, foreign_key: true
      t.references :delivery_person, foreign_key: true
      t.string :number, null: false
      t.integer :order_type, default: 0, null: false
      t.integer :status, default: 0, null: false
      t.decimal :subtotal, precision: 10, scale: 2, default: 0, null: false
      t.decimal :delivery_fee, precision: 10, scale: 2, default: 0, null: false
      t.decimal :discount, precision: 10, scale: 2, default: 0, null: false
      t.decimal :total, precision: 10, scale: 2, default: 0, null: false
      t.text :delivery_address
      t.text :notes
      t.datetime :estimated_delivery_at

      t.timestamps
    end

    add_index :orders, :number, unique: true
  end
end
