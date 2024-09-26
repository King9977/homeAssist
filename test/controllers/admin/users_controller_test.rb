require "test_helper"
require "mocha/minitest"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = mock('user')
    @admin_user.stubs(:admin?).returns(true)
    @admin_user.stubs(:id).returns(1)
    @admin_user.stubs(:groups).returns([])

    Admin::UsersController.any_instance.stubs(:current_user).returns(@admin_user)
  end

  test "should get index as admin" do
    group = mock('group')
    group.stubs(:id).returns(1)

    @admin_user.stubs(:groups).returns([group])
    user = mock('user')
    user.stubs(:groups).returns([group])

    User.stubs(:joins).returns(User)
    User.stubs(:where).returns([user])

    get admin_users_path
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should redirect non-admin from index" do
    @admin_user.stubs(:admin?).returns(false)

    get admin_users_path
    assert_redirected_to home_path
    assert_equal 'Nur Administratoren haben Zugriff auf diese Seite.', flash[:alert]
  end

  test "should get edit as admin" do
    edited_user = mock('user')
    edited_user.stubs(:id).returns(2)
    edited_user.stubs(:groups).returns([])

    User.stubs(:find).returns(edited_user)
    @admin_user.stubs(:groups).returns([])

    get edit_admin_user_path(2)
    assert_response :success
    assert_not_nil assigns(:user)
    assert_not_nil assigns(:common_groups)
  end

  test "should update user as admin" do
    updated_user = mock('user')
    updated_user.stubs(:id).returns(2)
    updated_user.stubs(:update).returns(true)
    
    User.stubs(:find).returns(updated_user)

    patch admin_user_path(2), params: { user: { name: "Updated Name", email: "new@example.com", role: 1 } }

    assert_redirected_to admin_users_path
    assert_equal 'Benutzer wurde erfolgreich aktualisiert.', flash[:notice]
  end

  test "should not update user with invalid params" do
    updated_user = mock('user')
    updated_user.stubs(:id).returns(2)
    updated_user.stubs(:update).returns(false)

    User.stubs(:find).returns(updated_user)

    patch admin_user_path(2), params: { user: { name: "", email: "invalid_email" } }

    assert_response :success
    assert_template :edit
  end

  test "should promote user to admin" do
    user = mock('user')
    user.stubs(:id).returns(2)
    User.stubs(:find).returns(user)

    Admin::UsersController.any_instance.stubs(:promote_to_admin)

    patch admin_user_path(2), params: { promote_to_admin: true }

    assert_redirected_to admin_users_path
  end

  test "should demote user to regular" do
    user = mock('user')
    user.stubs(:id).returns(2)
    User.stubs(:find).returns(user)

    Admin::UsersController.any_instance.stubs(:demote_to_user)

    patch admin_user_path(2), params: { demote_to_user: true }

    assert_redirected_to admin_users_path
  end
end
