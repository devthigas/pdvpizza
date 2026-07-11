class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.references :order, null: false, foreign_key: true
      t.integer :payment_method, default: 0, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.decimal :change_amount, precision: 10, scale: 2, default: 0, null: false

      t.timestamps
    end
  end
end
