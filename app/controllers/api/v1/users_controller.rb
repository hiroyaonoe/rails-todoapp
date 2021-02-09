class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /api/v1/user
  def show
    render json: @user, status: :ok
  end

  # POST /api/v1/user
  def create
    @user = User.new(user_params)
    if @user.save
      log_in
      render json: @user, status: :created
    else
      render json: @user.errors.full_messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/user
  def update
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: @user.errors.full_messages, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/user
  def destroy
    @user.destroy
    render status: :ok
  end

  private

    # Only allow a list of trusted parameters through.
    def user_params
      params.permit(:name, :email, :password)
    end
end
