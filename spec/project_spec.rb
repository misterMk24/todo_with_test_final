require 'rails_helper'
require 'rspec_api_documentation/dsl'


resource 'Projects' do
  header "Content-Type", "application/json"

  explanation "Projects resource"

  # creating data before examples

  let!(:project_first) { Project.create(:title => 'projet_first', :created_by => 'First_owner') }
  let!(:project_second) { Project.create(:title => 'projet_second', :created_by => 'Second_owner') }

  
  parameter :title, "Project name", :required => true
  parameter :created_by, "Project owner"
  
  
  get "/projects" do
    example_request "Listing projects" do
      expect(response_status).to be 200
      projects = Project.all.to_json(:only => 
        [
          :id,
          :title,
          :created_by,
        ], 
        :include => :tasks)
      expect(response_body).to eq(projects)

      # Another way to make above action:
      # expect(response_body).to eq(ActiveModel::Serializer::CollectionSerializer.new(
      #   [project_first, project_second], serializer: ProjectSerializer).to_json)
    end
  end
  
  get "projects/:id" do
    let(:id) { project_first.id }
    example_request "Get the order with id" do
      project_response = JSON.parse(response_body)
      expect(status).to be 200
      expect(project_response.fetch("id")).to eq(id)

      # another way to make above action
      # expect(response_body).to eq(ProjectSerializer.new(project_first).to_json)
    end
  end

  post "/projects" do
    let(:title) { 'First_project' }
    let(:created_by) { 'Seleznev' }
    let(:raw_post) { params.to_json }     # raw_post gets the body of the request

    let(:request) { { project: { title: nil, created_by: created_by } } } 
    
    context 'without title' do
      example "Creating a project" do
        do_request(request)
        expect(status).to eq 400
      end
    end
    
    context 'with title' do
      example_request "Creating a project" do
        project = JSON.parse(response_body)
        expect(project.except("created_at", "updated_at", "id", "tasks")).to eq({
          "title" => title,
          "created_by" => created_by
        })
        expect(status).to eq 201

        # another way to make above action
        # expect(response_body).to eq(ProjectSerializer.new(Project.last).to_json)
        #  expect(response_body).to eq()
      end
    end
  end

  put "/projects/:id" do
    let(:id) { project_first.id }
    let(:title) { "project_NOT_first" }
    let(:raw_post) { params.to_json }

    example_request "Updating a project" do
      project = JSON.parse(response_body)
      expect(status).to eq 200
      expect(project.except("created_at", "updated_at", "id", "created_by", "tasks")).to eq({
        "title" => title,
      })
    end
  end

  delete "/projects/:id" do
    let(:id) { project_first.id }

    example_request "Deleting a project" do
      expect(status).to eq 204
    end
  end
end