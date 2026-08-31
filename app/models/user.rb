class User < ApplicationRecord
  has_many :user_games
  has_many :games, through: :user_games

  before_validation :normalize_username

  validates :username, presence: true
  validates :username_normalized, uniqueness: true
  validates :password_digest, presence: true

  has_secure_password

  def self.find_by_username(username)
    find_by(username_normalized: username.to_s.downcase)
  end

  private

  def normalize_username
    self.username_normalized = username.to_s.downcase
  end
end
