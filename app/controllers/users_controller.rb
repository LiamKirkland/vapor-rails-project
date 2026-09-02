class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :require_admin, only: [:admin_edit, :admin_update]
  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.where.not(id: current_user_id).alpha_sort
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

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if changing_password? && !@user.authenticate(params[:user][:current_pass])
      flash.now[:alert] = "Incorrect password"
      render :edit, status: :unprocessable_entity
      return
    end

    if @user.update(user_params)
      @user.profile_pic.purge if params[:user][:remove_profile_pic] == "1"
      redirect_to root_path, notice: "Profile updated"
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def admin_edit
    @user = User.find(params[:id])
    redirect_to edit_profile_path, notice: "You cannot edit your own admin status." and return if @user == current_user
  end

  def admin_update
    @user = User.find(params[:id])

    if @user == current_user && params[:user][:admin] != "1"
      flash.now[:alert] = "You can't remove your own admin status"
      render :admin_edit, status: :unprocessable_entity
      return
    end

    if @user.update(admin_user_params)
      @user.profile_pic.purge if params[:user][:remove_profile_pic] == "1"
      redirect_to user_path(@user), notice: "Profile updated"
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :admin_edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :profile_pic)
  end

  def require_admin
    redirect_to root_path, alert: "You don't have permission to do that" unless current_user&.admin?
  end

  def admin_user_params
    params.require(:user).permit(:username, :profile_pic, :admin)
  end

  def changing_password?
    params[:user][:password].present?
  end
end
