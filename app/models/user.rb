class User < ApplicationRecord
  has_many :user_games
  has_many :games, through: :user_games

  validates :username, presence: true
  validates :password_digest, presence: true

  has_secure_password
end
