class Api::V1::UsersController < ApplicationController
  before_action :authenticate, only: [:show, :update, :destroy]

  # GET /api/v1/user
  def show
    render json: @user, status: :ok
  end

  # POST /api/v1/user
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      error_response(:unprocessable_entity, @user.errors.full_messages.join)
    end
  end

  # PATCH/PUT /api/v1/user
  def update
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      error_response(:unprocessable_entity, @user.errors.full_messages.join)
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
