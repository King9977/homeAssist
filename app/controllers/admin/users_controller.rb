class Admin::UsersController < ApplicationController
  before_action :require_admin

  def index
    current_user_groups = current_user.groups
    @users = User.joins(:groups).where(groups: { id: current_user_groups.ids }).distinct
  end

  def edit
    @user = User.find(params[:id])
    
    @common_groups = current_user.groups & @user.groups
    @is_group_admin = @common_groups.any? { |group| group.admin_id == current_user.id }
  end

  def update
  @user = User.find(params[:id])

  if params[:promote_to_admin]
    promote_to_admin
  elsif params[:demote_to_user]
    demote_to_user
  else
    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'Benutzer wurde erfolgreich aktualisiert.'
    else
      render :edit
    end
  end
end

  private

  def require_admin
    redirect_to home_path, alert: 'Nur Administratoren haben Zugriff auf diese Seite.' unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(:name, :email, :role)
  end
end
