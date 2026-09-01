class UserGamesController < ApplicationController
  def create
    game = Game.find(params[:game_id])
    user_game = current_user.user_games.build(game: game)

    if user_game.save
      redirect_to game, notice: "Successfully added to your collection"
    else
      redirect_to game, alert: "There was an issue adding the game to your collection. Refresh and try again."
    end
  end

  def destroy
    user_game = current_user.user_games.find(params[:id])
    user_game.destroy
    redirect_to user_game.game, notice: "Successfully removed from your collection"
  end
end
