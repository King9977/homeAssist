require 'test_helper'

class TaskResourceTest < ActiveSupport::TestCase
  def setup
    @group = Group.create(name: "Test Group", creator: User.create(name: "Creator", email: "creator@example.com", password: "password123", password_confirmation: "password123"))
    @task = Task.create(title: "Test Task", description: "Task description", group: @group, user: @group.creator)
    @resource = Resource.create(name: "Test Resource", group: @group)
    @task_resource = TaskResource.new(task: @task, resource: @resource)
  end

  test "should be valid with valid task and resource" do
    assert @task_resource.valid?
  end

  test "should require a task" do
    @task_resource.task = nil
    assert_not @task_resource.valid?
  end

  test "should require a resource" do
    @task_resource.resource = nil
    assert_not @task_resource.valid?
  end
end
