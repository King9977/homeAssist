class AddDescriptionToResources < ActiveRecord::Migration[7.0]
  def change
    add_column :resources, :description, :string
  end
end
