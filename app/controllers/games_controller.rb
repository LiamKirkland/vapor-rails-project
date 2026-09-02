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

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    if @game.update(game_params)
      @game.cover_image.purge if params[:game][:remove_cover_image] == "1"
      redirect_to game_path(@game), notice: "Game updated"
    else
      flash.now[:alert] = @game.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def game_params
    params.require(:game).permit(:name, :developer, :release_date, :cover_image)
  end
end
