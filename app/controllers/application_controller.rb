class ApplicationController < ActionController::Base
  before_action :require_login
  allow_browser versions: :modern
  stale_when_importmap_changes
  helper_method :current_user
  add_flash_types :warn

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def current_user_id
    session[:user_id]
  end

  def current_user
    @current_user ||= User.find_by(id: current_user_id)
  end

  def require_login
    return if current_user

    flash[:alert] = "You must be logged in."
    redirect_to login_path
  end

private

  def record_not_found
    flash[:alert] = "Entry not found."
    redirect_to root_path
  end
end
