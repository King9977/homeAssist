class GroupPolicy < ApplicationPolicy
  def create?
    user.admin?
  end

  def join?
    user.present?
  end
end
