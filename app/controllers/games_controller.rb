class GamesController < ApplicationController
  def show
    @game = Game.find(params[:id])
  end

  def index
    @games = Game.sorted_list
  end
  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      redirect_to game_path(@game)
    else
      flash.now[:alert] = @game.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  private

  def game_params
    params.require(:game).permit(:name, :developer, :release_date, :cover_image)
  end
end
