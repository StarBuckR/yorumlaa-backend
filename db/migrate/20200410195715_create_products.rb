class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :title
      t.boolean :approval, default: false
      t.boolean :age_restriction, default: false

      t.timestamps
    end
  end
end
