class CreateCategoryNames < ActiveRecord::Migration[6.0]
  def change
    create_table :category_names do |t|
      t.string :category_name

      t.timestamps
    end
  end
end
