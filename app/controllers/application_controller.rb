class ApplicationController < ActionController::API
  include ActionController::Cookies

  private

    # 現在ログイン中のユーザーを設定する（いる場合）
    def current_user
      @user ||= User.find_by(id: cookies[:id])

      # if session[:user_id]
      #   @user ||= User.find_by(id: session[:user_id])
      # end
    end

    # ユーザーがログインしていればtrue、その他ならfalseを返す
    def logged_in?
      !current_user.nil?
    end

    # ユーザーのログインを確認する
    def logged_in_user
      unless logged_in?
        render json: "Unauthorized", status: :unauthorized
      end
    end
end
