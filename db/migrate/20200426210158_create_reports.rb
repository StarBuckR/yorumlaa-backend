class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.integer :user_id
      t.integer :comment_id
      t.text :report_body

      t.timestamps
    end
  end
end
