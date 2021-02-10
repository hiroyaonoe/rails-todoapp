class AddSomeValidatesToTasks < ActiveRecord::Migration[6.1]
  def change
    change_column_null    :tasks, :title, false
    change_column_default :tasks, :is_completed, from: nil, to: false
  end
end
