class CreateCustomers < ActiveRecord::Migration[8.1]
  def change
    create_table :customers do |t|
      t.string :name, null: false
      t.string :cpf_cnpj
      t.string :phone, null: false
      t.text :address
      t.string :neighborhood
      t.string :reference_point
      t.text :notes

      t.timestamps
    end

    add_index :customers, :cpf_cnpj
  end
end
