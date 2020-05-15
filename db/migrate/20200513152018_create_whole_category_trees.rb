class CreateWholeCategoryTrees < ActiveRecord::Migration[6.0]
  def change
    create_table :whole_category_trees do |t|
      t.json :tree

      t.timestamps
    end
  end
end
