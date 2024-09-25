class Group < ApplicationRecord
  has_many :tasks, dependent: :destroy
  belongs_to :creator, class_name: 'User'

  has_many :group_memberships, dependent: :destroy
  has_many :users, through: :group_memberships

  has_many :group_admins_memberships, -> { where(admin: true) }, class_name: 'GroupMembership'
  has_many :group_admins, through: :group_admins_memberships, source: :user

  validates :name, presence: true

  has_many :resources, dependent: :destroy

  after_create :make_creator_admin

  def admin?(user)
    group_admins.include?(user)
  end
  
  private

  def make_creator_admin
    group_membership = GroupMembership.find_or_create_by(user: creator, group: self)
    group_membership.update(admin: true)
  end
end
