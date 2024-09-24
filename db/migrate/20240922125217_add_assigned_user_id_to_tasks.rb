class AddAssignedUserToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :assigned_user_id, :integer
    add_foreign_key :tasks, :users, column: :assigned_user_id
  end
end
