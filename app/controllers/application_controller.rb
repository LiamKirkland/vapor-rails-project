class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  helper_method :current_user, :logged_in?

  def current_user_id
    session[:user_id]
  end

  def current_user
    @current_user ||= User.find_by(id: current_user_id)
  end

  def logged_in?
    current_user.present?
  end
end