class AddNameToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :first_name, :string, required: false
    add_column :users, :last_name, :string, required: false
  end
end
