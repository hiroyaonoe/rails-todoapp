class Api::V1::TasksController < ApplicationController
  before_action :authenticate_user
  before_action :set_allowed_tasks
  before_action :set_task, only: [:show, :update, :destroy]

  # GET /api/v1/tasks
  def index
    if params[:start]
      @tasks = @tasks.where("deadline >= ?", params[:start])
    end
    if params[:end]
      @tasks = @tasks.where("deadline <= ?", params[:end])
    end
    if params[:iscomp]
      @tasks = @tasks.where("is_completed = ?",
                          ActiveModel::Type::Boolean.new.cast(params[:iscomp]))
    end

    render json: @tasks, status: :ok
  end

  # GET /api/v1/tasks/:id
  def show
    render json: @task, status: :ok
  end

  # POST /api/v1/tasks
  def create
    @task = @tasks.new(task_params)
    if @task.save
      render json: @task, status: :created
    else
      render json: @task.errors.full_messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/tasks/:id
  def update
    if @task.update(task_params)
      render json: @task, status: :ok
    else
      render json: @task.errors.full_messages, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/tasks/:id
  def destroy
    @task.destroy
    render status: :ok
  end

  private

    # そのユーザーが持つタスクのみを抽出
    def set_allowed_tasks
      @tasks = @user.tasks
    end

    # パスパラメータからタスクを検索してセットする
    def set_task
      @task = @tasks.find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.permit(:title, :content, :is_completed, :deadline)
    end
end
