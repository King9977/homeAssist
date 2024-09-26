require 'test_helper'

class GroupMembershipTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Test User', email: 'test@example.com', password: 'password123', password_confirmation: 'password123')
    @group = Group.new(name: 'Test Group')
    @group_membership = GroupMembership.new(user: @user, group: @group)
  end

  test "should be valid with valid attributes" do
    assert @group_membership.valid?
  end

  test "should belong to a user" do
    assert_equal @user, @group_membership.user
  end

  test "should belong to a group" do
    assert_equal @group, @group_membership.group
  end

  test "should be invalid without a user" do
    @group_membership.user = nil
    assert_not @group_membership.valid?
    assert_includes @group_membership.errors[:user], "must exist"
  end

  test "should be invalid without a group" do
    @group_membership.group = nil
    assert_not @group_membership.valid?
    assert_includes @group_membership.errors[:group], "must exist"
  end
end
