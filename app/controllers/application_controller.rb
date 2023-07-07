class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :logged_in?
  helper_method :get_new_nonce

  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def require_login
    redirect_to login_path unless logged_in?
  end

  def require_authorize
    if current_user.id != params[:id]
      redirect_to users_path, alert: "You are not authorized to edit this user."
    end
  end

  def get_new_nonce
    SecureRandom.uuid
  end
end
