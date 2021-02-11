class Api::V1::SessionsController < ApplicationController

  # POST /api/v1/login
  def create
    @user = User.find_by(email: params[:email].downcase)
    if @user && @user.authenticate(params[:password])
      @user.set_token
      render json: { token: encoded_token(@user.id, @user.session_token) },
             status: :created
    else
      render json: "Login Failed", status: :unauthorized
    end
  end

  # DELETE /api/v1/logout
  def destroy
    authenticate_user
    @user.delete_token if @user
    render status: :ok
  end

  private

    # セッション用トークンとUserIDを結合したトークンを返す
    def encoded_token(id,session_token)
      auth_table = { id: id, session_token: session_token }
      CGI.escape(Base64.encode64(JSON.dump(auth_table)))
    end
end
