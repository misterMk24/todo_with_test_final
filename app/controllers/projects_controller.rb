class ProjectsController < ApplicationController
  def index
    @projects = Project.all
    render json: @projects, status: :ok
  end

  def show
    @project = Project.find(params[:id])
    render json: @project, :status => :ok
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      render json: @project, status: :created
    else
      render json: @project.errors, status: 400
    end
  end

  def update
    @project = Project.find(params[:id])
    @project.update(project_params)
    render json: @project, :status => :ok
  end
  
  def destroy
    @projects = Project.all
    @project = @projects.find(params[:id])
    @project.destroy
    render status: :no_content
  end
  
  private

  def project_params
    params.require(:project).permit(:title, :created_by)
  end
end
