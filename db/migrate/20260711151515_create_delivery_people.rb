class CreateDeliveryPeople < ActiveRecord::Migration[8.1]
  def change
    create_table :delivery_people do |t|
      t.string :name, null: false
      t.string :phone, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
