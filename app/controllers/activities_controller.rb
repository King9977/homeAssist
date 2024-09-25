class ActivitiesController < ApplicationController
  before_action :require_login

  def index
    @activities = PaperTrail::Version.order(created_at: :desc)  end
end
