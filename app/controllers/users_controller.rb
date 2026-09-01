class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  def show
    @user = User.find(params[:id])
  end

  def home
    @user = User.find(current_user_id)
  end
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
