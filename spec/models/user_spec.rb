require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to have_secure_password }

    it "is invalid without a unique username (case-insensitive)" do
      create(:user, username: "CoolGuy12")
      duplicate = build(:user, username: "coolguy12")

      expect(duplicate).not_to be_valid
    end

    it "rejects usernames with invalid characters" do
      user = build(:user, username: "bad name!")

      expect(user).not_to be_valid
    end

    it "accepts usernames with periods, underscores, and dashes" do
      user = build(:user, username: "cool.guy_12-2")

      expect(user).to be_valid
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:user_games) }
    it { is_expected.to have_many(:games).through(:user_games) }
    it { is_expected.to have_many(:friendships) }
  end

  describe "#admin?" do
    it "returns true for an admin user" do
      expect(create(:user, :admin).admin?).to eq(true)
    end

    it "returns false for a regular user" do
      expect(create(:user).admin?).to eq(false)
    end
  end

  describe "#friends_with?" do
    it "returns true when there is an accepted friendship" do
      user = create(:user)
      friend = create(:user)
      create(:friendship, user: user, friend: friend, status: "accepted")

      expect(user.friends_with?(friend)).to eq(true)
    end

    it "returns false when there is only a pending friendship" do
      user = create(:user)
      friend = create(:user)
      create(:friendship, user: user, friend: friend, status: "pending")

      expect(user.friends_with?(friend)).to eq(false)
    end
  end

  describe "#friendship_status_with" do
    it "returns :self when comparing a user to themself" do
      user = create(:user)
      expect(user.friendship_status_with(user)).to eq(:self)
    end

    it "returns :none when there is no friendship" do
      expect(create(:user).friendship_status_with(create(:user))).to eq(:none)
    end
  end

  describe ".find_by_username" do
    it "finds a user regardless of case" do
      create(:user, username: "CoolGuy12")
      expect(User.find_by_username("coolguy12")).to be_present
    end
  end

  describe ".alpha_sort" do
    it "orders users alphabetically, case-insensitively" do
      create(:user, username: "zeta")
      create(:user, username: "Alpha")

      expect(User.alpha_sort.map(&:username)).to eq(%w[Alpha zeta])
    end
  end
end