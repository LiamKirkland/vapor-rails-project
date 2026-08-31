class AddUserNameNormalizationToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :username_normalized, :string
    add_index :users, :username_normalized, unique: true
  end
end
