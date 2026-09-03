FactoryBot.define do
  factory :friendship do
    user
    friend factory: :user
    status { "pending" }
  end
end