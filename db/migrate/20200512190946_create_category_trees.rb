class CreateCategoryTrees < ActiveRecord::Migration[6.0]
  def change
    create_table :category_trees do |t|
      t.string :current_category
      t.string :parent_category

      t.timestamps
    end
  end
end
