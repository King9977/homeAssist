class ChangeUserIdInTasksNullable < ActiveRecord::Migration[7.2]
  def up
    change_column :tasks, :user_id, :integer, null: true
  end

  def down
    change_column :tasks, :user_id, :integer, null: false
  end
end
