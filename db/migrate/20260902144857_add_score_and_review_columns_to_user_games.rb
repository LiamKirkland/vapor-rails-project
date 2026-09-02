class AddScoreAndReviewColumnsToUserGames < ActiveRecord::Migration[8.1]
  def change
    add_column :user_games, :score, :integer
    add_column :user_games, :review, :text
  end
end
