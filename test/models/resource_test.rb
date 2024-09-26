require 'test_helper'

class ResourceTest < ActiveSupport::TestCase
  def setup
    @group = Group.create(name: 'Test Group', creator: User.first)
    @resource = Resource.new(name: 'Test Resource', group: @group)
  end

  test "should be valid with valid attributes" do
    assert @resource.valid?
  end

  test "should be invalid without a name" do
    @resource.name = nil
    assert_not @resource.valid?
    assert_includes @resource.errors[:name], "can't be blank"
  end

  test "should be invalid without a group" do
    @resource.group = nil
    assert_not @resource.valid?
    assert_includes @resource.errors[:group], "must exist"
  end

  test "should have many tasks through task_resources" do
    task1 = Task.create(title: 'Task 1', group: @group)
    task2 = Task.create(title: 'Task 2', group: @group)

    @resource.tasks << task1
    @resource.tasks << task2

    assert_equal 2, @resource.tasks.count
    assert_includes @resource.tasks, task1
    assert_includes @resource.tasks, task2
  end
end
