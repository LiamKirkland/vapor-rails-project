class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  def new; end

  def create
    user = User.find_by_username(params[:user][:username])

    if user&.authenticate(params[:user][:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Logged in successfully"
    else
      flash.now[:alert] = "Invalid username or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete :user_id
    redirect_to login_path
  end
end
