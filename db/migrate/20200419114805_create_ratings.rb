class CreateRatings < ActiveRecord::Migration[6.0]
  def change
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :product_id
      t.integer :product_category_id
      t.integer :rating_value

      t.timestamps
    end
  end
end
