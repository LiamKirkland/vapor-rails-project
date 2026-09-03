require 'rails_helper'

RSpec.describe Friendship, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:friend).class_name("User") }
  end

  describe "validations" do
    it { is_expected.to validate_inclusion_of(:status).in_array(%w[pending accepted]) }

    it "is invalid when the user and friend are the same person" do
      user = create(:user)
      expect(build(:friendship, user: user, friend: user)).not_to be_valid
    end
  end
end