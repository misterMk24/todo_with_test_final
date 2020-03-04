class TasksController < ApplicationController
  def index
    @project = Project.find(params[:project_id])
    @task = @project.tasks.all
    render json: @task, status: :ok
  end

  def create
    @project = Project.find(params[:project_id])
    @task = @project.tasks.new(task_params)
    if @task.save
      render json: @task, status: :created
    else
      render json: @task.errors, status: 400
    end
  end

  def update
    @task = Task.find(params[:id])
    @task.update(task_params)
    render json: @task, status: :ok
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    render status: :no_content
  end

  private

  def task_params
    params.require(:task).permit(:name_task, :done, :priority)
  end

end
