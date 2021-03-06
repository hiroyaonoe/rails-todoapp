class Api::V1::AuthController < ApplicationController
  before_action :authenticate, only: :destroy

  # POST /api/v1/login
  def create
    @user = User.find_by(email: params[:email].downcase)
    if @user && @user.authenticate(params[:password])
      @user.set_auth_token
      render json: { token: @user.access_token },
             status: :created
    else
      error_response(:unauthorized, "Login Failed.")
    end
  end

  # DELETE /api/v1/logout
  def destroy
    @user.delete_auth_token if @user
    render status: :ok
  end
end
