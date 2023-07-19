class AddColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :age, :integer
    add_column :users, :phone, :string
    add_column :users, :role, :integer, default: 0
  end
end
