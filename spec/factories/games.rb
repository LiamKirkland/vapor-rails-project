FactoryBot.define do
  factory :game do
    sequence(:name) { |n| "Test Game #{n}" }
    developer { "Test Studio" }
    release_date { 1.year.ago }
  end
end