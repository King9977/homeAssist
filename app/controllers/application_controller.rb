class ApplicationController < ActionController::Base
  
  include PaperTrail::Rails::Controller  # Modul für PaperTrail einbinden

  
  before_action :set_paper_trail_whodunnit

  # Diese Methode wird von PaperTrail verwendet, um festzustellen, wer eine Änderung gemacht hat
  def user_for_paper_trail
    current_user ? current_user.id : 'Anonymous' # Verwende current_user, um den aktuell angemeldeten Benutzer zu ermitteln
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
      redirect_to login_path, alert: 'Bitte loggen Sie sich ein, um fortzufahren.'
    end
  end

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Nur Administratoren dürfen auf diese Seite zugreifen.'
    end
  end

  # Hilfsmethode, um zu prüfen, ob der aktuelle Benutzer Admin ist
  def admin?
    current_user&.admin?
  end
end