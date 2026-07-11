class CreateCashRegisters < ActiveRecord::Migration[8.1]
  def change
    create_table :cash_registers do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :opening_balance, precision: 10, scale: 2, null: false
      t.decimal :closing_balance, precision: 10, scale: 2
      t.integer :status, default: 0, null: false
      t.datetime :opened_at, null: false
      t.datetime :closed_at
      t.text :observations

      t.timestamps
    end
  end
end
