class Api::V1::SessionsController < ApplicationController

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      log_in user
      remember user
    else
      render json: "Bad Request", status: :bad_request
    end
  end

  def destroy
    log_out if logged_in?
  end

  private
    
    # 渡されたユーザーでログインする
    def log_in(user)
      session[:user_id] = user.id
    end

    # ユーザーのセッションを永続的にする
    def remember(user)
      user.remember
      cookies.signed[:user_id] = { value: user.id, expires: 1.hour.from_now }
      cookies[:remember_token] = { value: user.remember_token, expires: 1.hour.from_now }
    end



    # 永続的セッションを破棄する
    def forget(user)
      user.forget
      cookies.delete(:user_id)
      cookies.delete(:remember_token)
    end

    # 現在のユーザーをログアウトする
    def log_out
      forget(current_user)
      session.delete(:user_id)
      @current_user = nil
    end
end
