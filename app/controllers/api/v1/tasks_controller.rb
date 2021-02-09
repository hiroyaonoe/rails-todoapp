class Api::V1::TasksController < ApplicationController
  before_action :set_user
  before_action :set_task, only: [:show, :update, :destroy]

  # GET /api/v1/tasks
  def index
    @tasks = Task.all

    render json: @tasks, status: :ok
  end

  # GET /api/v1/tasks/:id
  def show
    render json: @task, status: :ok
  end

  # POST /api/v1/tasks
  def create
    @task = @user.tasks.new(task_params)
    if @task.save
      render json: @task, status: :created
    else
      render json: "Bad Request", status: :bad_request
    end
  end

  # PATCH/PUT /api/v1/tasks/:id
  def update
    if @task.update(task_params)
      render json: @task, status: :ok
    else
      render json: "Bad Request", status: :bad_request
    end
  end

  # DELETE /api/v1/tasks/:id
  def destroy
    @task.destroy
    render status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find_by(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.permit(:title, :content, :is_completed, :deadline)
    end
end
