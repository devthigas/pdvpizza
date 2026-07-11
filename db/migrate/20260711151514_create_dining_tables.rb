class CreateDiningTables < ActiveRecord::Migration[8.1]
  def change
    create_table :dining_tables do |t|
      t.integer :number, null: false
      t.integer :seats, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :dining_tables, :number, unique: true
  end
end
