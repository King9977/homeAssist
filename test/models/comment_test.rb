require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Test User', email: 'test@example.com', password: 'password123', password_confirmation: 'password123')
    @task = Task.new(title: 'Test Task', description: 'Test description', due_date: Date.today)
    @comment = Comment.new(body: 'Test comment', user: @user, task: @task)
  end

  test "should be valid with valid attributes" do
    assert @comment.valid?
  end

  test "should be invalid without body" do
    @comment.body = nil
    assert_not @comment.valid?
    assert_includes @comment.errors[:body], "can't be blank"
  end

  test "should belong to a user" do
    assert_equal @user, @comment.user
  end

  test "should belong to a task" do
    assert_equal @task, @comment.task
  end
end
