class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 12 }, allow_nil: true

  has_secure_password

  attr_accessor :current_password
  
  enum role: { user: 0, admin: 1 }
  
  def display_role
    if admin?
      "Premium"
    else
      "Basic"
    end
  end

  has_many :group_memberships
  has_many :groups, through: :group_memberships
  has_many :created_groups, class_name: 'Group', foreign_key: 'creator_id'
end
