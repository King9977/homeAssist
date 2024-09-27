require "test_helper"
require "mocha/minitest"

class ActivitiesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = mock('user')
    ActivitiesController.any_instance.stubs(:current_user).returns(@user)
    ActivitiesController.any_instance.stubs(:logged_in?).returns(true)
  end

  test "should get index when logged in" do
    activities = mock('activities')
    PaperTrail::Version.stubs(:order).returns(activities)

    get activities_path
    assert_response :success
    assert_not_nil assigns(:activities)
  end

  test "should redirect when not logged in" do
    ActivitiesController.any_instance.stubs(:logged_in?).returns(false)

    get activities_path
    assert_redirected_to login_path
  end
end
