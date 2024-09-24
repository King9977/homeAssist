class CreateJoinTableTasksResources < ActiveRecord::Migration[7.2]
  def change
    create_join_table :tasks, :resources do |t|
      # t.index [:task_id, :resource_id]
      # t.index [:resource_id, :task_id]
    end
  end
end
