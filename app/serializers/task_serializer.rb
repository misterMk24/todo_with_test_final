class TaskSerializer < ActiveModel::Serializer
  attributes :id, :name_task, :done, :priority
end
