class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :content
      t.boolean :is_completed
      t.date :deadline
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :tasks, [:user_id, :deadline]
  end
end
