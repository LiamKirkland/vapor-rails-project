require 'rails_helper'

RSpec.describe Game, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:developer) }
    it { is_expected.to validate_presence_of(:release_date) }

    it "is invalid if a game with the same name, developer, and release date already exists" do
      create(:game, name: "Marathon", developer: "Bungie", release_date: Date.new(1994, 12, 21))
      dupe = build(:game, name: "Marathon", developer: "Bungie", release_date: Date.new(1994, 12, 21))

      expect(dupe).not_to be_valid
    end

    it "allows two games with the same name but a different developer" do
      create(:game, name: "Marathon", developer: "Bungie", release_date: Date.new(1994, 12, 21))
      different_dev = build(:game, name: "Marathon", developer: "Other Studio", release_date: Date.new(2026, 1, 1))

      expect(different_dev).to be_valid
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:user_games) }
    it { is_expected.to have_many(:users).through(:user_games) }
  end

  describe "#formatted_release" do
    it "formats the release date as MM/DD/YYYY" do
      game = build(:game, release_date: Date.new(2024, 2, 20))
      expect(game.formatted_release).to eq("02/20/2024")
    end
  end

  describe "#release_year" do
    it "returns the year of the release date" do
      game = build(:game, release_date: Date.new(2024, 2, 20))
      expect(game.release_year).to eq(2024)
    end
  end

  describe "#avg_score" do
    it "returns N/A when there are no scores" do
      expect(create(:game).avg_score).to eq("N/A")
    end

    it "returns the average of all scores" do
      game = create(:game)
      create(:user_game, game: game, score: 8)
      create(:user_game, game: game, score: 10)

      expect(game.avg_score).to eq(9.0)
    end
  end

  describe ".find_by_name" do
    it "finds games regardless of case" do
      create(:game, name: "Marathon")
      expect(Game.find_by_name("marathon")).to be_present
    end
  end

  describe ".sorted_list" do
    it "orders games alphabetically, case-insensitively" do
      create(:game, name: "zelda")
      create(:game, name: "Alien")

      expect(Game.sorted_list.map(&:name)).to eq(%w[Alien zelda])
    end
  end

  describe ".unreleased_games" do
    it "only includes games with a future release date" do
      past = create(:game, release_date: 1.year.ago)
      future = create(:game, release_date: 1.year.from_now)

      expect(Game.unreleased_games).to include(future)
      expect(Game.unreleased_games).not_to include(past)
    end
  end
end