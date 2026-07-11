class CreateFlavors < ActiveRecord::Migration[8.1]
  def change
    create_table :flavors do |t|
      t.string :name, null: false
      t.string :description
      t.string :ingredients
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :flavors, :name, unique: true
  end
end
