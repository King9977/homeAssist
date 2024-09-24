class ActivitiesController < ApplicationController
  def index
    @activities = PaperTrail::Version.order(created_at: :desc)
  end
end
