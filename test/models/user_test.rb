require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Test User", email: "test@example.com", password: "password123456", password_confirmation: "password123456")
  end

  test "should be valid with valid attributes" do
    assert @user.valid?
  end

  test "should require email" do
    @user.email = nil
    assert_not @user.valid?
    assert_includes @user.errors[:email], "can't be blank"
  end

  test "should require unique email" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
    assert_includes duplicate_user.errors[:email], "has already been taken"
  end

  test "should require password of minimum length" do
    @user.password = @user.password_confirmation = "short"
    assert_not @user.valid?
    assert_includes @user.errors[:password], "is too short (minimum is 12 characters)"
  end

  test "should allow nil password when updating other attributes" do
    @user.save
    @user.password = @user.password_confirmation = nil
    assert @user.valid?
  end

  test "should return correct role display" do
    @user.save
    assert_equal "Basic", @user.display_role
    @user.admin!
    assert_equal "Premium", @user.display_role
  end

  test "should have many group memberships" do
    @user.save
    group = Group.create(name: "Test Group", creator: @user)
    group.users << @user
    assert_includes @user.groups, group
  end

  test "should have many created groups" do
    @user.save
    group = Group.create(name: "Created Group", creator: @user)
    assert_includes @user.created_groups, group
  end
end
