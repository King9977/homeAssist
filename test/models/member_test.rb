require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  def setup
    @user = User.create(name: 'Test User', email: 'testuser@example.com', password: 'password123', password_confirmation: 'password123')
    @group = Group.create(name: 'Test Group', creator: @user)
    @member = Member.new(user: @user, group: @group)
  end

  test "should be valid with valid attributes" do
    assert @member.valid?
  end

  test "should be invalid without a user" do
    @member.user = nil
    assert_not @member.valid?
    assert_includes @member.errors[:user], "must exist"
  end

  test "should be invalid without a group" do
    @member.group = nil
    assert_not @member.valid?
    assert_includes @member.errors[:group], "must exist"
  end

  test "should belong to a user" do
    assert_equal @user, @member.user
  end

  test "should belong to a group" do
    assert_equal @group, @member.group
  end
end
