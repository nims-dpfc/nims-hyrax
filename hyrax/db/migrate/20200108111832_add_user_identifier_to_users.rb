class AddUserIdentifierToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :user_identifier, :string #, null: false
    add_index :users, :user_identifier, unique: true
  end
end
