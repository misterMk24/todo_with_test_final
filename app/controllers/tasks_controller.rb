class TasksController < ApplicationController
  expose :project
  expose :task, build_params: :task_params
  expose :tasks, ->{ project.tasks } 

  def index
    render json: tasks.order(:priority), status: :ok
  end

  def create
    task_create = tasks.new(task_params)
    if task_create.save
      render json: task_create, status: :created
    else
      render json: task_create.errors, status: 400
    end
  end

  def update
    task.update(task_params)
    render json: task, status: :ok
  end

  def destroy
    task.destroy
    render status: :no_content
  end

  private

  def task_params
    params.require(:task).permit(:name_task, :done, :priority)
  end

end
