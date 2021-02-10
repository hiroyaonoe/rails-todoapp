class RemoveIndexTasksOnUserId < ActiveRecord::Migration[6.1]
  def change
    remove_index :tasks, :user_id
  end
end
