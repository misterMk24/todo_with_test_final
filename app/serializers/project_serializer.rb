class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :title, :created_by
  has_many :tasks

  def tasks
    object.tasks.order(:priority)
  end
end
