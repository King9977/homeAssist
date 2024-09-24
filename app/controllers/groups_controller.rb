class GroupsController < ApplicationController
  before_action :require_admin, only: [:new, :create]
  before_action :set_group, only: [:show, :kick_user, :promote_to_admin, :leave_group]  # Hier sicherstellen, dass set_group vor promote_to_admin aufgerufen wird


  # Zeigt alle Gruppen, denen der Benutzer beigetreten ist oder die er erstellt hat
  def index
    @groups = current_user.groups + current_user.created_groups
    @groups = current_user.groups.distinct

  end

  # Gruppendetails anzeigen
  def show
    @members = @group.users # Alle Mitglieder der Gruppe
    @group_code = @group.code # Der Gruppenbeitrittscode
  end

  # Zeigt das Formular für den Beitritt zu einer Gruppe
  def join
  end

  # Verarbeitet den Beitritt zu einer Gruppe
  def join_group
    group = Group.find_by(code: params[:group_code])

    if group
      group.users << current_user unless group.users.include?(current_user)
      flash[:notice] = 'Du bist der Gruppe erfolgreich beigetreten.'
      redirect_to groups_path
    else
      flash.now[:alert] = 'Ungültiger Gruppen-Code.'
      render :join
    end
  end

  # Methode für das Erstellen einer Gruppe (nur für Admins)
  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.creator = current_user
    @group.code = SecureRandom.hex(4)
    if @group.save
      flash[:notice] = "Gruppe wurde erfolgreich erstellt. Der Gruppen-Code lautet: #{@group.code}"
      redirect_to group_path(@group)
    else
      flash.now[:alert] = "Fehler beim Erstellen der Gruppe."
      render :new
    end
  end

  # Benutzer aus der Gruppe entfernen (nur für Admins)
  def kick_user
    user = User.find(params[:user_id])
    if @group.group_admins.include?(current_user) # Überprüfen, ob der aktuelle Benutzer Admin ist
      @group.users.delete(user)
      
      redirect_to group_path(@group), notice: "#{user.name} wurde aus der Gruppe entfernt."
    else
      redirect_to group_path(@group), alert: "Nur Gruppenadmins können Benutzer entfernen."
    end
  end

def promote_to_admin
  user = User.find(params[:user_id])
  if @group.group_admins.include?(current_user)  # Überprüfen, ob der aktuelle Benutzer ein Admin ist
    unless @group.group_admins.include?(user)  # Überprüfen, ob der Benutzer bereits Admin ist
      @group.group_admins << user  # Benutzer zum Admin machen
      redirect_to group_path(@group), notice: "#{user.name} wurde zum Gruppenadmin befördert."
    else
      redirect_to group_path(@group), alert: "#{user.name} ist bereits ein Gruppenadmin."
    end
  else
    redirect_to group_path(@group), alert: "Nur Gruppenadmins können Benutzer zu Admins befördern."
  end
end
  
  def leave_group
  if @group.users.count == 1
    # Lösche die Gruppe und alle damit verknüpften Datensätze, wenn nur ein Benutzer übrig ist
    @group.destroy
    redirect_to groups_path, notice: 'Die Gruppe wurde gelöscht, da du das letzte Mitglied warst.'
  else
    @group.users.delete(current_user)
    
    if @group.group_admins.empty?
      new_admin = @group.users.sample
      @group.group_admins << new_admin
      flash[:notice] = "#{new_admin.name} wurde zum neuen Gruppenadmin ernannt."
    end

    redirect_to groups_path, notice: 'Du hast die Gruppe erfolgreich verlassen.'
  end
end
    
  def make_creator_admin
  GroupMembership.create!(user: creator, group: self, admin: true)
  end


  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
