require "test_helper"
require "mocha/minitest"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = mock('user')
    @task = mock('task')
    @group = mock('group')
    @comment = mock('comment')
    @controller = CommentsController.new

    @user.stubs(:id).returns(1)
    @task.stubs(:id).returns(1)
    @task.stubs(:group).returns(@group)
    @comment.stubs(:id).returns(1)

    Task.stubs(:find).with(@task.id).returns(@task)
    @task.stubs(:comments).returns([@comment])
  end

  test "should create comment successfully" do
    @task.comments.stubs(:build).returns(@comment)
    @comment.stubs(:user=).with(@user)
    @comment.stubs(:save).returns(true)
    @controller.stubs(:current_user).returns(@user)

    post group_task_comments_path(@task.group, @task), params: { comment: { content: "Test comment" } }

    assert_redirected_to group_task_path(@task.group, @task)
    assert_equal 'Kommentar hinzugefügt.', flash[:notice]
  end

  test "should fail to create comment and redirect" do
    @task.comments.stubs(:build).returns(@comment)
    @comment.stubs(:user=).with(@user)
    @comment.stubs(:save).returns(false)
    @controller.stubs(:current_user).returns(@user)

    post group_task_comments_path(@task.group, @task), params: { comment: { content: "Test comment" } }

    assert_redirected_to group_task_path(@task.group, @task)
    assert_equal 'Fehler beim Hinzufügen des Kommentars.', flash[:alert]
  end
end
