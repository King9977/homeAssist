class ApplicationController < ActionController::Base
  
  include PaperTrail::Rails::Controller
  before_action :set_paper_trail_whodunnit

  def user_for_paper_trail
    current_user ? current_user.id : 'Anonymous'
  end
  
  helper_method :current_user, :logged_in?, :admin?
  include SessionsHelper

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    unless logged_in?
      flash[:alert] = "Bitte loggen Sie sich ein, um auf diese Seite zuzugreifen."
      redirect_to login_path
    end
  end

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Nur Administratoren dürfen auf diese Seite zugreifen.'
    end
  end

  def admin?
    current_user&.admin?
  end
end
