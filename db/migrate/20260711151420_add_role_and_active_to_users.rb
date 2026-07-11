class AddRoleAndActiveToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :role, :integer, default: 0, null: false
    add_column :users, :active, :boolean, default: true, null: false
  end
end
