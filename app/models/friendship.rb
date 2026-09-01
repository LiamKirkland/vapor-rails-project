class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"

  validates :status, inclusion: { in: %w[pending accepted] }
  validate :not_self_friendship

  private

  def not_self_friendship
    errors.add(:friend, "can't be yourself") if user_id == friend_id
  end
end
