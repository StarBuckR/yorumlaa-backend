class CreateProductRatings < ActiveRecord::Migration[6.0]
  def change
    create_table :product_ratings do |t|
      t.integer :product_id
      t.string :category_name

      t.timestamps
    end
  end
end
