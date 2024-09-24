class CreateGroupAdminsGroupsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_table :group_admins_groups, id: false do |t|
      t.references :group, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
    end
  end
end
