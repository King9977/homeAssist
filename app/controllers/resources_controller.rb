class ResourcesController < ApplicationController
  before_action :set_group
  before_action :set_resource, only: [:edit, :update, :destroy]
  before_action :require_group_admin, only: [:edit, :update, :destroy]

  def index
    @resources = @group.resources
  end

  def new
    @resource = @group.resources.build
  end

  def create
    @resource = @group.resources.build(resource_params)
    if @resource.save
      redirect_to group_resources_path(@group), notice: 'Ressource wurde erfolgreich erstellt.'
    else
      render :new
    end
  end

  def edit
    # Bearbeitungslogik
  end

  def update
    if @resource.update(resource_params)
      redirect_to group_resources_path(@group), notice: 'Ressource wurde erfolgreich aktualisiert.'
    else
      render :edit
    end
  end

  def destroy
  if @group.admin?(current_user)
    @resource.destroy
    redirect_to group_resources_path(@group), notice: 'Ressource wurde erfolgreich gelöscht.'
  else
    redirect_to group_resources_path(@group), alert: 'Nur Gruppenadmins können Ressourcen löschen.'
  end
end


  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_resource
    @resource = @group.resources.find(params[:id])
  end

  def resource_params
    params.require(:resource).permit(:name, :quantity)
  end

  # Methode, um zu überprüfen, ob der aktuelle Benutzer ein Gruppenadmin ist
  def require_group_admin
    unless @group.group_admins.include?(current_user)
      redirect_to group_resources_path(@group), alert: 'Nur Gruppenadmins können diese Aktion ausführen.'
    end
  end
end
