require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  def setup
    @user = User.create(name: "Test User", email: "test@example.com", password: "password123", password_confirmation: "password123")
    @group = Group.create(name: "Test Group", creator: @user)
    @task = Task.new(title: "Test Task", description: "Task description", due_date: 1.week.from_now, status: :offen, group: @group, assigned_user: @user)
  end

  test "should be valid with valid attributes" do
    assert @task.valid?
  end

  test "should require a title" do
    @task.title = nil
    assert_not @task.valid?
    assert_includes @task.errors[:title], "can't be blank"
  end

  test "should require a description" do
    @task.description = nil
    assert_not @task.valid?
    assert_includes @task.errors[:description], "can't be blank"
  end

  test "should require a due date" do
    @task.due_date = nil
    assert_not @task.valid?
    assert_includes @task.errors[:due_date], "can't be blank"
  end

  test "should require a status" do
    @task.status = nil
    assert_not @task.valid?
    assert_includes @task.errors[:status], "can't be blank"
  end

  test "should have a default status comment" do
    assert_nil @task.status_comment
    @task.status_comment = "This is a comment"
    assert_equal "This is a comment", @task.status_comment
  end

  test "should belong to a group" do
    assert_equal @group, @task.group
  end

  test "can have an assigned user" do
    assert_equal @user, @task.assigned_user
  end

  test "should have many comments" do
    assert_difference '@task.comments.count', 1 do
      @task.comments.create!(user: @user, content: "Test comment")
    end
  end

  test "should have many resources" do
    resource = Resource.create(name: "Test Resource", group: @group)
    @task.resources << resource
    assert_includes @task.resources, resource
  end

  test "should track changes with PaperTrail" do
    assert_difference '@task.versions.count', 1 do
      @task.update(title: "Updated Task Title")
    end
  end
end
