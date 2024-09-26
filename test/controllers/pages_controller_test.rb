require 'test_helper'
require 'mocha/minitest'

class PagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = mock('user')
    @user.stubs(:groups).returns(['Group 1', 'Group 2'])
    @activities = ['Activity 1', 'Activity 2']
    PaperTrail::Version.stubs(:order).returns(stub(limit: @activities))
  end

  test "should get home when logged in" do
    PagesController.any_instance.stubs(:current_user).returns(@user)
    PagesController.any_instance.stubs(:logged_in?).returns(true)
    get home_url
    assert_response :success
    assert_equal ['Group 1', 'Group 2'], assigns(:groups)
    assert_equal @activities, assigns(:activities)
  end

  test "should get home when not logged in" do
    PagesController.any_instance.stubs(:logged_in?).returns(false)
    get home_url
    assert_response :success
    assert_nil assigns(:groups)
    assert_equal @activities, assigns(:activities)
  end
end
