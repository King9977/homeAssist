class Resource < ApplicationRecord
  validates :name, presence: true
  has_many :task_resources
  has_many :tasks, through: :task_resources
  belongs_to :group
  has_and_belongs_to_many :tasks
end
