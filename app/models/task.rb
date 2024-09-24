class Task < ApplicationRecord
  belongs_to :assigned_user, class_name: 'User', optional: true
  has_many :comments, dependent: :destroy
  belongs_to :group
  has_and_belongs_to_many :resources
  
  validates :title, :description, :due_date, presence: true
  validates :status, presence: true

  enum status: { offen: 0, in_bearbeitung: 1, erledigt: 2 }

  attribute :status_comment, :string
  has_paper_trail
end
