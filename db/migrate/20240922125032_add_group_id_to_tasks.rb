class AddGroupIdToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :group_id, :integer
    add_index :tasks, :group_id  # Optional, fügt einen Index hinzu, um die Abfrageleistung zu verbessern
  end
end
