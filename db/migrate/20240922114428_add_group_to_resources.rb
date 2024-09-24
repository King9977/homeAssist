class AddGroupToResources < ActiveRecord::Migration[7.2]
  def change
    add_reference :resources, :group, null: false, foreign_key: true
  end
end
