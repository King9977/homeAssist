require "test_helper"
require "mocha/minitest"

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = mock('user')
    @admin_user = mock('admin_user')
    @controller = ApplicationController.new

    @user.stubs(:id).returns(1)
    @user.stubs(:admin?).returns(false)
    
    @admin_user.stubs(:id).returns(2)
    @admin_user.stubs(:admin?).returns(true)
  end

  test "should return current_user when logged in" do
    session[:user_id] = @user.id
    User.stubs(:find).with(@user.id).returns(@user)

    assert_equal @user, @controller.current_user
  end

  test "should return nil when not logged in" do
    session[:user_id] = nil
    assert_nil @controller.current_user
  end

  test "should detect logged in user" do
    @controller.stubs(:current_user).returns(@user)
    assert @controller.logged_in?
  end

  test "should require login and redirect if not logged in" do
    @controller.stubs(:logged_in?).returns(false)
    get root_path
    assert_redirected_to login_path
  end

  test "should require admin and redirect if not admin" do
    @controller.stubs(:current_user).returns(@user)
    @controller.stubs(:admin?).returns(false)
    
    get admin_users_path
    assert_redirected_to root_path
  end

  test "should allow access for admin user" do
    @controller.stubs(:current_user).returns(@admin_user)
    @controller.stubs(:admin?).returns(true)
    
    get admin_users_path
    assert_response :success
  end

  test "should set PaperTrail whodunnit" do
    @controller.stubs(:current_user).returns(@user)
    assert_equal @user.id, @controller.user_for_paper_trail
  end
end
