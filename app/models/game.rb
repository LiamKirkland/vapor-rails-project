class Game < ApplicationRecord
  has_many :user_games
  has_many :users, through: :user_games

  normalizes :name, with: ->(name) { name.strip }
  validates :name, presence: true
  validates :developer, presence: true
  validates :release_date, presence: true

  def formatted_release
    release_date.strftime("%m/%d/%Y")
  end
end
