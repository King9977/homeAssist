class CreateResources < ActiveRecord::Migration[6.1]
  def change
    create_table :resources do |t|
      t.string :name
      t.integer :quantity
      t.references :group, null: false, foreign_key: true  # Verknüpft Ressourcen mit Gruppen

      t.timestamps
    end
  end
end
