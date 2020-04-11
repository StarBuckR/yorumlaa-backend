class AddAdminToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :role, :string, default: "user"
    remove_column :users, :admin
  end
end
