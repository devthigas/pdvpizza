class CreateAdditionals < ActiveRecord::Migration[8.1]
  def change
    create_table :additionals do |t|
      t.string :name, null: false
      t.string :description
      t.decimal :price, precision: 10, scale: 2, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
