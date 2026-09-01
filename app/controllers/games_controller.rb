class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
  end

  private

  def game_params
    params.require(:game).permit()
  end
end
