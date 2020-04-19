class CreateRatingCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :rating_categories do |t|
      t.string :category_name

      t.timestamps
    end
  end
end
