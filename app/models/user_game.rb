class UserGame < ApplicationRecord
  belongs_to :game
  belongs_to :user

  validates :score, numericality: { in: 0..10 }, allow_nil: true
end
