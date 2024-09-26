require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  def setup
    @creator = User.create(name: 'Creator User', email: 'creator@example.com', password: 'password123', password_confirmation: 'password123')
    @group = Group.new(name: 'Test Group', creator: @creator)
  end

  test "should be valid with valid attributes" do
    assert @group.valid?
  end

  test "should be invalid without a name" do
    @group.name = nil
    assert_not @group.valid?
    assert_includes @group.errors[:name], "can't be blank"
  end

  test "should belong to a creator" do
    assert_equal @creator, @group.creator
  end

  test "should have tasks" do
    @group.save
    task = @group.tasks.create(title: "Sample Task", description: "Sample task description")
    assert_includes @group.tasks, task
  end

  test "should have users through group memberships" do
    @group.save
    user = User.create(name: 'Test User', email: 'test@example.com', password: 'password123', password_confirmation: 'password123')
    @group.users << user
    assert_includes @group.users, user
  end

  test "should create a group admin for the creator after creation" do
    @group.save
    assert_includes @group.group_admins, @creator
  end

  test "should correctly identify a group admin" do
    @group.save
    assert @group.admin?(@creator)

    user = User.create(name: 'Other User', email: 'other@example.com', password: 'password123', password_confirmation: 'password123')
    @group.users << user
    assert_not @group.admin?(user)
  end

  test "should delete associated tasks when group is destroyed" do
    @group.save
    @group.tasks.create(title: "Sample Task", description: "Sample task description")
    assert_difference 'Task.count', -1 do
      @group.destroy
    end
  end

  test "should delete associated resources when group is destroyed" do
    @group.save
    @group.resources.create(name: "Sample Resource", quantity: 1)
    assert_difference 'Resource.count', -1 do
      @group.destroy
    end
  end

  test "should delete associated group memberships when group is destroyed" do
    @group.save
    user = User.create(name: 'Test User', email: 'test@example.com', password: 'password123', password_confirmation: 'password123')
    @group.users << user
    assert_difference 'GroupMembership.count', -1 do
      @group.destroy
    end
  end
end
