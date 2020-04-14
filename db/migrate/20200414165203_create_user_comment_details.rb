class CreateUserCommentDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :user_comment_details do |t|
      t.integer :comment_id
      t.integer :user_id
      t.boolean :like

      t.timestamps
    end
  end
end
