class ProjectsController < ApplicationController
  expose :projects, ->{ Project.all }
  expose :project

  def index
    render json: projects, status: :ok
  end

  def show
    render json: project, :status => :ok
  end

  def create
    if project.save
      render json: project, status: :created
    else
      render json: project.errors, status: 400
    end
  end

  def update
    project.update(project_params)
    render json: project, :status => :ok
  end
  
  def destroy
    project.destroy
    render status: :no_content
  end
  
  private

  def project_params
    params.require(:project).permit(:title, :created_by)
  end
end
