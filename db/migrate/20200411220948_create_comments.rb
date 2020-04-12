class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :body
      t.integer :like, default: 0
      t.integer :dislike, default: 0

      t.integer :product_id

      t.integer :user_id
      t.string :username

      t.timestamps
    end
  end
end
