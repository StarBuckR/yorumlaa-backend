class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.integer :product_id
      t.json :categories

      t.timestamps
    end
  end
end
