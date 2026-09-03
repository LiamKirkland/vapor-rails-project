require 'rails_helper'

RSpec.describe UserGame, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:game) }
  end

  describe "validations" do
    it "allows a blank score" do
      expect(build(:user_game, score: nil)).to be_valid
    end

    it "allows a score between 0 and 10" do
      expect(build(:user_game, score: 7)).to be_valid
    end

    it "rejects a score above 10" do
      expect(build(:user_game, score: 11)).not_to be_valid
    end

    it "rejects a score below 0" do
      expect(build(:user_game, score: -1)).not_to be_valid
    end
  end

  describe ".reviewed" do
    it "only includes user_games with a score" do
      reviewed = create(:user_game, score: 8)
      unreviewed = create(:user_game, score: nil)

      expect(UserGame.reviewed).to include(reviewed)
      expect(UserGame.reviewed).not_to include(unreviewed)
    end
  end
end