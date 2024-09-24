class UsersController < ApplicationController
  before_action :require_login
 
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if params[:user][:password].present?
      unless @user.authenticate(params[:user][:current_password])
        flash.now[:alert] = 'Aktuelles Passwort ist falsch.'
        render :edit and return
      end
    end

    if params[:user][:email] != @user.email
      @user.new_email = params[:user][:email]
      @user.email_confirmation_token = SecureRandom.hex(10)
      if @user.save
        confirmation_link = confirm_email_url(@user.email_confirmation_token)
        Rails.logger.debug "Bestätigungslink: #{confirmation_link}"
        flash[:notice] = 'E-Mail-Bestätigung gesendet. Überprüfe deine neue E-Mail-Adresse.'
        render :edit and return
      end
    end

    if @user.update(user_params.except(:current_password))
      flash[:notice] = 'Profil erfolgreich aktualisiert.'
      redirect_to profile_path
    else
      flash.now[:alert] = 'Profilaktualisierung fehlgeschlagen.'
      render :edit
    end
  end

  def confirm_email
    @user = User.find_by(email_confirmation_token: params[:token])

    if @user && @user.update(email: @user.new_email, new_email: nil, email_confirmation_token: nil)
      redirect_to profile_path, notice: 'E-Mail-Adresse erfolgreich bestätigt.'
    else
      redirect_to profile_path, alert: 'Ungültiger oder abgelaufener Bestätigungslink.'
    end
  end
  
  def make_admin
    @user = current_user
    if @user.update(role: :admin)
      redirect_to profile_path, notice: 'Herzlichen Glückwunsch! Sie haben jetzt Premium rechte.'
    else
      redirect_to profile_path, alert: 'Fehler beim Aktualisieren der Rolle.'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end

  def require_login
    unless logged_in?
      redirect_to login_path, alert: 'Bitte loggen Sie sich ein, um fortzufahren.'
    end
  end
end
