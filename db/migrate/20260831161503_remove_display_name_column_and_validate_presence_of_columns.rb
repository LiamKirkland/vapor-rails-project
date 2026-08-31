class RemoveDisplayNameColumnAndValidatePresenceOfColumns < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :display_name, :string
    change_column_null :users, :username, false
    change_column_null :users, :password_digest, false
    change_column_null :games, :name, false
    change_column_null :games, :developer, false
    change_column_null :games, :release_date, false
  end
end
