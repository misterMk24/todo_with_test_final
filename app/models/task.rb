class Task < ApplicationRecord
  belongs_to :project
  validates :name_task, presence: true
end
