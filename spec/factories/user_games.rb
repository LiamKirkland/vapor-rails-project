FactoryBot.define do
  factory :user_game do
    user
    game
    score { nil }
    review { nil }
  end
end