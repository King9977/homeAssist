module SessionsHelper

  # Methode, um den aktuell eingeloggten Benutzer zu erhalten
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # Methode, um zu überprüfen, ob ein Benutzer eingeloggt ist
  def logged_in?
    !current_user.nil?
  end

  # Methode zum Abmelden des Benutzers
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
