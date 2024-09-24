class Admin::UsersController < ApplicationController
  before_action :require_admin

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'Benutzerdetails erfolgreich aktualisiert.'
    else
      render :edit
    end
  end

  private

  def require_admin
    redirect_to old_home_path, alert: 'Nur Administratoren haben Zugriff auf diese Seite.' unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(:name, :email, :role)
  end
end
