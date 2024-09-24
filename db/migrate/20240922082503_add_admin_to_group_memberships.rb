class AddAdminToGroupMemberships < ActiveRecord::Migration[7.0]
  def change
    add_column :group_memberships, :admin, :boolean, default: false
  end
end
