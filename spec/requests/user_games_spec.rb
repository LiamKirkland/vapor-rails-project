require 'rails_helper'

RSpec.describe "UserGames", type: :request do
  let(:user) { create(:user) }
  let(:game) { create(:game) }

  def log_in_as(user)
    post login_path, params: { user: { username: user.username, password: "password123" } }
  end

  describe "POST /games/:game_id/user_games" do
    it "adds the game to the current user's collection" do
      log_in_as(user)

      expect {
        post game_user_games_path(game)
      }.to change { user.reload.games.count }.by(1)
    end

    it "redirects to the game page" do
      log_in_as(user)
      post game_user_games_path(game)

      expect(response).to redirect_to(game_path(game))
    end
  end

  describe "PATCH /games/:game_id/user_games/:id" do
    it "updates the score and review" do
      log_in_as(user)
      user_game = create(:user_game, user: user, game: game)

      patch game_user_game_path(game, user_game), params: { user_game: { score: 9, review: "Great game!" } }

      user_game.reload
      expect(user_game.score).to eq(9)
      expect(user_game.review).to eq("Great game!")
    end
  end

  describe "DELETE /user_games/:id" do
    it "removes the game from the user's collection" do
      log_in_as(user)
      user_game = create(:user_game, user: user, game: game)

      expect {
        delete user_game_path(user_game)
      }.to change { user.reload.games.count }.by(-1)
    end
  end

  describe "when not logged in" do
    it "redirects to login instead of adding the game" do
      post game_user_games_path(game)
      expect(response).to redirect_to(login_path)
    end
  end
end