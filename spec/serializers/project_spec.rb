require 'rails_helper'


RSpec.describe Project, type: :serializer do
  let!(:project) { Project.create(:title => "some_project", :created_by => "some_owner") }
  let!(:task)  { project.tasks.create(:name_task => "some_task", :priority => 10) }
  let!(:task_2)  { project.tasks.create(:name_task => "some_task_2", :priority => 1) }
  let!(:project_serializer) { ProjectSerializer.new(project) }
  
  describe 'attributes' do
    it 'ensures that output represented in json format' do
      expect(project_serializer.serializable_hash.except(:tasks).to_json).to eq(
        project.to_json(:only => [
          :id,
          :title,
          :created_by
        ]
        ))
    end
  end

  describe '#tasks' do
    it 'returns tasks within a project by the order (priority)' do
      expect(project_serializer.tasks.to_json).to eq(project.tasks.order(:priority).to_json)
    end
  end
end