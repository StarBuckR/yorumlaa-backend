class CreateRatings < ActiveRecord::Migration[6.0]
  def change
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :product_id
      #t.string :rating_category_names, array: true
      #t.integer :rating_values, array: true
      t.json :ratings

      t.timestamps
    end
  end
end
