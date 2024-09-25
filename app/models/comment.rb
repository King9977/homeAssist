class Comment < ApplicationRecord
  belongs_to :task
  belongs_to :usera
  validates :body, presence: true
end
