class Api::V1::AuthController < ApplicationController
  before_action :authenticate_user, only: :destroy

  # POST /api/v1/login
  def create
    @user = User.find_by(email: params[:email].downcase)
    if @user && @user.authenticate(params[:password])
      @user.set_auth_token
      render json: { token: access_token(@user.id, @user.auth_token) },
             status: :created
    else
      render json: "Login Failed", status: :unauthorized
    end
  end

  # DELETE /api/v1/logout
  def destroy
    @user.delete_auth_token if @user
    render status: :ok
  end

  private

    # 認証トークンとUserIDを結合したアクセストークンを返す
    def access_token(id, auth_token)
      access_table = { id: id, auth_token: auth_token }
      CGI.escape(Base64.encode64(JSON.dump(access_table)))
    end
end
