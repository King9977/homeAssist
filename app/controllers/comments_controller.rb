class CommentsController < ApplicationController
  before_action :set_task

  def create
    @comment = @task.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to group_task_path(@task.group, @task), notice: 'Kommentar hinzugefügt.'
    else
      redirect_to group_task_path(@task.group, @task), alert: 'Fehler beim Hinzufügen des Kommentars.'
    end
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
