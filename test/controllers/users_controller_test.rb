require 'test_helper'
require 'mocha/minitest'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = mock('user')
    @user.stubs(:id).returns(1)
    @user.stubs(:email).returns('test@example.com')
    @user.stubs(:new_email).returns(nil)
    @user.stubs(:authenticate).returns(true)
    @user.stubs(:update).returns(true)
    
    UsersController.any_instance.stubs(:current_user).returns(@user)
    UsersController.any_instance.stubs(:logged_in?).returns(true)
  end

  test "should get show" do
    get profile_url
    assert_response :success
    assert_equal @user, assigns(:user)
  end

  test "should get edit" do
    get edit_profile_url
    assert_response :success
    assert_equal @user, assigns(:user)
  end

  test "should update user with valid password" do
    @user.stubs(:authenticate).with('current_password').returns(true)
    @user.stubs(:update).returns(true)

    patch profile_url, params: { user: { name: 'Updated Name', email: 'test@example.com', current_password: 'current_password' } }
    assert_redirected_to profile_url
    assert_equal 'Profil erfolgreich aktualisiert.', flash[:notice]
  end

  test "should not update user with invalid current password" do
    @user.stubs(:authenticate).with('wrong_password').returns(false)

    patch profile_url, params: { user: { name: 'Updated Name', email: 'test@example.com', current_password: 'wrong_password' } }
    assert_response :success
    assert_equal 'Aktuelles Passwort ist falsch.', flash[:alert]
  end

  test "should send email confirmation when email changes" do
    @user.stubs(:email).returns('old@example.com')
    @user.stubs(:new_email=).returns('new@example.com')
    @user.stubs(:email_confirmation_token=).returns(SecureRandom.hex(10))
    @user.stubs(:save).returns(true)

    patch profile_url, params: { user: { email: 'new@example.com' } }
    assert_response :success
    assert_equal 'E-Mail-Bestätigung gesendet. Überprüfe deine neue E-Mail-Adresse.', flash[:notice]
  end

  test "should confirm email with valid token" do
    User.stubs(:find_by).with(email_confirmation_token: 'valid_token').returns(@user)
    @user.stubs(:update).with(email: @user.new_email, new_email: nil, email_confirmation_token: nil).returns(true)

    get confirm_email_url(token: 'valid_token')
    assert_redirected_to profile_url
    assert_equal 'E-Mail-Adresse erfolgreich bestätigt.', flash[:notice]
  end

  test "should not confirm email with invalid token" do
    User.stubs(:find_by).with(email_confirmation_token: 'invalid_token').returns(nil)

    get confirm_email_url(token: 'invalid_token')
    assert_redirected_to profile_url
    assert_equal 'Ungültiger oder abgelaufener Bestätigungslink.', flash[:alert]
  end

  test "should make user admin" do
    @user.stubs(:update).with(role: :admin).returns(true)

    patch make_admin_profile_url
    assert_redirected_to profile_url
    assert_equal 'Herzlichen Glückwunsch! Sie haben jetzt Premium rechte.', flash[:notice]
  end

  test "should fail to make user admin" do
    @user.stubs(:update).with(role: :admin).returns(false)

    patch make_admin_profile_url
    assert_redirected_to profile_url
    assert_equal 'Fehler beim Aktualisieren der Rolle.', flash[:alert]
  end
end
