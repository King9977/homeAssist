class TasksController < ApplicationController
  before_action :set_group
  before_action :set_task, only: [:edit, :update, :destroy, :update_status]
  before_action :require_login
  
  def index
    @group = Group.find(params[:group_id])
    @tasks = @group.tasks
  end

  def new
    @task = @group.tasks.build
    @task = @group.tasks.new
    @group = Group.find(params[:group_id])
  end

  def create
    @task = @group.tasks.build(task_params)
    @group = Group.find(params[:group_id])
    @task.user_id = current_user.id  # Setzt den aktuellen Benutzer als Ersteller der Aufgabe
    @task.status ||= "offen"
  
    if @task.save
      redirect_to group_tasks_path(@group), notice: 'Aufgabe erfolgreich erstellt.'
    else
      render :new
    end
   end



  def edit
    @group = Group.find(params[:group_id])
    @task = @group.tasks.find(params[:id])
  end

  def update
    @group = Group.find(params[:group_id])
    @task = @group.tasks.find(params[:id])
    @task.status ||= "offen"
    
    if @task.update(task_params)
      redirect_to group_tasks_path(@group), notice: 'Aufgabe erfolgreich aktualisiert.'
    else
      render :edit
    end
  end

  def destroy
  if @group.admin?(current_user)
    @task.destroy
    redirect_to group_tasks_path(@group), notice: 'Aufgabe erfolgreich gelöscht.'
  else
    redirect_to group_tasks_path(@group), alert: 'Nur Gruppenadministratoren können Aufgaben löschen.'
  end
end


   def update_status
    @task = @group.tasks.find(params[:id])
    
    if @task.update(status: params[:task][:status], status_comment: params[:task][:status_comment])
      redirect_to group_tasks_path(@group), notice: 'Status und Kommentar erfolgreich aktualisiert.'
    else
      render :edit_status
    end
  end
  
  def edit_status
    @group = Group.find(params[:group_id])
    @task = @group.tasks.find(params[:id])
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_task
    @task = @group.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :assigned_user_id, :status, :status_comment, resource_ids: [])
  end
end