class AddCreatorAndAdminsToGroups < ActiveRecord::Migration[7.0]
  def change
    add_column :groups, :creator_id, :integer
    add_column :groups, :admin_id, :integer
  end
end
