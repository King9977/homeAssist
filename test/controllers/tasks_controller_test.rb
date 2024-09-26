require 'test_helper'
require 'mocha/minitest'

class TasksControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = mock('user')
    @user.stubs(:id).returns(1)
    @group = mock('group')
    @group.stubs(:id).returns(1)
    @group.stubs(:tasks).returns([@task])
    @group.stubs(:admin?).returns(true)
    
    @task = mock('task')
    @task.stubs(:id).returns(1)
    @task.stubs(:group).returns(@group)
    @task.stubs(:title).returns("Test Task")
    @task.stubs(:description).returns("Test Description")
    @task.stubs(:status).returns("offen")
    @task.stubs(:user_id).returns(@user.id)
    
    Group.stubs(:find).returns(@group)
    @group.stubs(:tasks).returns([@task])

    @task.stubs(:save).returns(true)
    @task.stubs(:update).returns(true)
    @task.stubs(:destroy).returns(true)
  end

  test "should get index" do
    get group_tasks_url(@group)
    assert_response :success
  end

  test "should get new" do
    get new_group_task_url(@group)
    assert_response :success
  end

  test "should create task" do
    post group_tasks_url(@group), params: { task: { title: "New Task", description: "Task Description", user_id: @user.id } }
    assert_redirected_to group_tasks_url(@group)
    assert_equal 'Aufgabe erfolgreich erstellt.', flash[:notice]
  end

  test "should get edit" do
    get edit_group_task_url(@group, @task)
    assert_response :success
  end

  test "should update task" do
    patch group_task_url(@group, @task), params: { task: { title: "Updated Task", description: "Updated Description" } }
    assert_redirected_to group_tasks_url(@group)
    assert_equal 'Aufgabe erfolgreich aktualisiert.', flash[:notice]
  end

  test "should destroy task" do
    delete group_task_url(@group, @task)
    assert_redirected_to group_tasks_url(@group)
    assert_equal 'Aufgabe erfolgreich gelöscht.', flash[:notice]
  end

  test "should update status" do
    patch update_status_group_task_url(@group, @task), params: { task: { status: "in_bearbeitung", status_comment: "Work in progress" } }
    assert_redirected_to group_tasks_url(@group)
    assert_equal 'Status und Kommentar erfolgreich aktualisiert.', flash[:notice]
  end
end
