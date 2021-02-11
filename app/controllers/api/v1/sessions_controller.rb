class Api::V1::SessionsController < ApplicationController

  # POST /api/v1/login
  def create
    @user = User.find_by(email: params[:email].downcase)
    if @user && @user.authenticate(params[:password])
      @user.set_token
      render json: @user.session_token, status: :created
    else
      render json: "login failed", status: :unauthorized
    end
  end

  # DELETE /api/v1/logout
  def destroy
    authenticate_user
    @user.delete_token if @user
  end
end
