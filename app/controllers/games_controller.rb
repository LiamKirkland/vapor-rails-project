class GamesController < ApplicationController
  def show
    @game = Game.find(params[:id])
  end

  def index
    @games = Game.all
  end
  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      redirect_to game_path(@game)
    end
  end

  private

  def game_params
    params.require(:game).permit(:name, :developer, :release_date)
  end
end
