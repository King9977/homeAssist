class ActivitiesController < ApplicationController
  def index
    @activities = PaperTrail::Version.order(created_at: :desc) # Aktivitäten laden
    @users = User.where(id: @activities.pluck(:whodunnit).compact).index_by(&:id) # Benutzer vorladen
  end
end
