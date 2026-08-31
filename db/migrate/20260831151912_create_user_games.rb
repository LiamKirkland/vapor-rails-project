class CreateUserGames < ActiveRecord::Migration[8.1]
  def change
    create_table :user_games do |t|
      t.references :user
      t.references :game
      t.timestamps
    end
  end
end
