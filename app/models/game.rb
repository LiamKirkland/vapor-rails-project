class Game < ApplicationRecord
  has_many :user_games
  has_many :users, through: :user_games

  validates :name, presence: true
  validates :developer, presence: true
  validates :release_date, presence: true
end
