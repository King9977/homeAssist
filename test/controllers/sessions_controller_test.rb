require 'test_helper'
require 'mocha/minitest'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = mock('user')
    @user.stubs(:id).returns(1)
    @user.stubs(:authenticate).with('password').returns(true)
    @user.stubs(:authenticate).with('wrong_password').returns(false)
    User.stubs(:find_by).with(email: 'user@example.com').returns(@user)
    User.stubs(:find_by).with(email: 'wrong@example.com').returns(nil)
  end

  test "should get new" do
    get login_url
    assert_response :success
  end

  test "should create session with valid credentials" do
    post login_url, params: { email: 'user@example.com', password: 'password' }
    assert_redirected_to home_url
    assert_equal 'Erfolgreich eingeloggt.', flash[:notice]
    assert_equal 1, session[:user_id]
  end

  test "should not create session with invalid password" do
    post login_url, params: { email: 'user@example.com', password: 'wrong_password' }
    assert_template :new
    assert_equal 'Ungültige E-Mail oder Passwort.', flash[:alert]
    assert_nil session[:user_id]
  end

  test "should not create session with invalid email" do
    post login_url, params: { email: 'wrong@example.com', password: 'password' }
    assert_template :new
    assert_equal 'Ungültige E-Mail oder Passwort.', flash[:alert]
    assert_nil session[:user_id]
  end

  test "should destroy session" do
    delete logout_url
    assert_redirected_to root_url
    assert_equal 'Du hast dich erfolgreich ausgeloggt.', flash[:notice]
    assert_nil session[:user_id]
  end
end
