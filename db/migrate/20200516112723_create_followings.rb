class CreateFollowings < ActiveRecord::Migration[6.0]
  def change
    create_table :followings do |t|
      t.integer :user_id
      t.integer :product_id
      t.integer :update_notif

      t.timestamps
    end
  end
end
