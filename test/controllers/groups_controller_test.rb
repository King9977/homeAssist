require 'test_helper'
require 'mocha/minitest'

class GroupsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @group = mock('group')
    @user = mock('user')
    @admin_user = mock('admin_user')
    @group.stubs(:id).returns(1)
    @group.stubs(:name).returns("Test Group")
    @group.stubs(:users).returns([@user])
    @group.stubs(:group_admins).returns([@admin_user])
    @group.stubs(:code).returns("1234abcd")
    @user.stubs(:id).returns(1)
    @admin_user.stubs(:id).returns(2)

    Group.stubs(:find).with(@group.id).returns(@group)
    @controller.stubs(:current_user).returns(@user)
    @controller.stubs(:require_login)
  end

  test "should get index" do
    Group.stubs(:all).returns([@group])
    @user.stubs(:groups).returns([@group])
    get groups_url
    assert_response :success
    assert_not_nil assigns(:groups)
  end

  test "should get show" do
    get group_url(@group.id)
    assert_response :success
    assert_equal @group, assigns(:group)
  end

  test "should join group with valid code" do
    Group.stubs(:find_by).with(code: "1234abcd").returns(@group)
    @group.stubs(:users).returns([@user])
    post join_group_url, params: { group_code: "1234abcd" }
    assert_redirected_to groups_url
    assert_equal 'Du bist der Gruppe erfolgreich beigetreten.', flash[:notice]
  end

  test "should fail to join group with invalid code" do
    Group.stubs(:find_by).with(code: "wrongcode").returns(nil)
    post join_group_url, params: { group_code: "wrongcode" }
    assert_response :success
    assert_equal 'Ungültiger Gruppen-Code.', flash[:alert]
  end

  test "should create group successfully" do
    Group.stubs(:new).returns(@group)
    @group.stubs(:save).returns(true)
    post groups_url, params: { group: { name: "Test Group" } }
    assert_redirected_to group_url(@group.id)
    assert_equal "Gruppe wurde erfolgreich erstellt. Der Gruppen-Code lautet: 1234abcd", flash[:notice]
  end

  test "should fail to create group" do
    Group.stubs(:new).returns(@group)
    @group.stubs(:save).returns(false)
    post groups_url, params: { group: { name: "Test Group" } }
    assert_response :success
    assert_equal "Fehler beim Erstellen der Gruppe.", flash[:alert]
  end

  test "should kick user as admin" do
    User.stubs(:find).with(@user.id).returns(@user)
    @group.stubs(:group_admins).returns([@admin_user])
    @group.stubs(:users).returns([@user])
    delete kick_user_group_url(@group.id, user_id: @user.id)
    assert_redirected_to group_url(@group.id)
    assert_equal "#{@user.name} wurde aus der Gruppe entfernt.", flash[:notice]
  end

  test "should not allow non-admin to kick user" do
    User.stubs(:find).with(@user.id).returns(@user)
    @group.stubs(:group_admins).returns([])
    delete kick_user_group_url(@group.id, user_id: @user.id)
    assert_redirected_to group_url(@group.id)
    assert_equal "Nur Gruppenadmins können Benutzer entfernen.", flash[:alert]
  end

  test "should leave group and destroy if last member" do
    @group.stubs(:users).returns([@user])
    @group.stubs(:destroy)
    delete leave_group_group_url(@group.id)
    assert_redirected_to groups_url
    assert_equal 'Die Gruppe wurde gelöscht, da du das letzte Mitglied warst.', flash[:notice]
  end

  test "should leave group and assign new admin" do
    new_admin = mock('new_admin')
    @group.stubs(:users).returns([@user, new_admin])
    @group.stubs(:group_admins).returns([])
    @group.stubs(:users).returns([new_admin])
    @group.stubs(:group_admins).returns([new_admin])
    delete leave_group_group_url(@group.id)
    assert_redirected_to groups_url
    assert_equal "#{new_admin.name} wurde zum neuen Gruppenadmin ernannt.", flash[:notice]
  end
end
