class AddEmailConfirmationToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :new_email, :string
    add_column :users, :email_confirmation_token, :string
  end
end
