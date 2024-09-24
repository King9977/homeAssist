class PagesController < ApplicationController
  def home
    @groups = current_user.groups if logged_in?
    @activities = PaperTrail::Version.order(created_at: :desc).limit(10)
  end
end
