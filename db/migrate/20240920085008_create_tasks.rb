class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.string :status, default: 'Offen'
      t.date :due_date
      t.references :group, null: false, foreign_key: true
      t.references :assigned_user, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
