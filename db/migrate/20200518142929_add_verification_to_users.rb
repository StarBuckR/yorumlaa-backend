class AddVerificationToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :verification, :string
  end
end
