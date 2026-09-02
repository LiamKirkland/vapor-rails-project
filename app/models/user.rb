class User < ApplicationRecord
  has_many :user_games
  has_many :games, through: :user_games
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :inv_friendships, class_name: "Friendship", foreign_key: :friend_id, dependent: :destroy
  has_many :inv_friends, through: :inv_friendships, source: :user
  has_one_attached :profile_pic

  normalizes :username, with: ->(username) { username.strip }
  before_validation :normalize_username

  validates :username, presence: true
  validates :username_normalized, uniqueness: true,
                      format: { with: /\A[a-zA-Z0-9._-]+\z/,
                                message: "can only contain letters, numbers, periods, underscores, and dashes" }
  validates :password_digest, presence: true

  scope :alpha_sort, -> { order(Arel.sql("LOWER(username)")) }

  has_secure_password

  def friends_list
    friends.merge(Friendship.where(status: "accepted")) +
      inv_friends.merge(Friendship.where(status: "accepted"))
  end

  def pending_requests
    inv_friendships.where(status: "pending").includes(:user).order(created_at: :desc)
  end

  def friends_with?(other_user)
    friendships.exists?(friend: other_user, status: "accepted") ||
      inv_friendships.exists?(user: other_user, status: "accepted")
  end

  def friendship_with(other_user)
    friendships.find_by(friend: other_user) || inv_friendships.find_by(user: other_user)
  end

  def friendship_status_with(other_user)
    return :self if self == other_user

    if friends_with?(other_user)
      :friends
    elsif friendships.exists?(friend: other_user, status: "pending")
      :pending_sent
    elsif inv_friendships.exists?(user: other_user, status: "pending")
      :pending_received
    else
      :none
    end
  end

  def display_profile_pic
    profile_pic.attached? ? profile_pic : "no-img.png"
  end

  def self.find_by_username(username)
    find_by(username_normalized: username.to_s.downcase)
  end

  private

  def normalize_username
    self.username_normalized = username.to_s.downcase
  end
end
