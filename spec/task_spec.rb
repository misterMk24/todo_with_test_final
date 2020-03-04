require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Tasks' do 
  header "Content-Type", "application/json"

  explanation "Tasks resource"

  let!(:project_first) { Project.create(:title => 'projet_first', :created_by => 'First_owner') }
  let(:project_id) { project_first.id }
  let!(:task) { project_first.tasks.create(:name_task => 'some_task', :done => false, :priority => 10) }
  # task = project_first.tasks.create(:name => 'some_task', :done => false, :priority => 10)

  with_options :required => true do
    parameter :name_task, "Task name"
    parameter :done, "Task status"
    parameter :priority, "Task priority"
  end

  get "projects/:project_id/tasks" do
    
    example_request "Get the tasks within a project" do
      task_response = project_first.tasks.to_json(:only => 
        [
          :id,
          :name_task,
          :done,
          :priority
        ])
      expect(status).to be 200
      expect(response_body).to eq(task_response)

      # another way to make above action
      # expect(response_body).to eq(ActiveModel::Serializer::CollectionSerializer.new(
      #  project_first.tasks, serializer: TaskSerializer).to_json)
    end
  end

  post "/projects/:project_id/tasks" do
    let(:name_task) { 'First_task' }
    let(:done) { false }
    let(:priority) { 100 }   
    let(:raw_post) { params.to_json }  # raw_post gets the body of the request
    let(:request) { { task: { name_task: nil, done: done, priority: priority } } } 
    
    context 'without title' do
      example "Creating a project" do
        do_request(request)
        expect(status).to eq 400
      end
    end
    
    context 'with title' do
      example_request "Creating a project" do
        project = JSON.parse(response_body)
        expect(project.except("project", "id")).to eq({
          "name_task" => name_task,
          "done" => done,
          "priority" => priority
        })
        expect(status).to eq 201

        # another way to make above action
        # expect(response_body).to eq(ProjectSerializer.new(Project.last).to_json)
        #  expect(response_body).to eq()
      end
    end
  end

  put "tasks/:id" do
    let(:id) { task.id }
    let(:name_task) { "NOT_some_task" }
    let(:raw_post) { params.to_json }

    example_request "Updating a project" do
      task_response = JSON.parse(response_body)
      expect(status).to eq 200
      expect(task_response.except("done", "priority", "id")).to eq({
        "name_task" => name_task,
      })
    end
  end


  delete "/tasks/:id" do
    let(:id) { task.id }

    example_request "Deleting a task" do
      expect(status).to eq 204
    end
  end
end