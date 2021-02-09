class ApplicationController < ActionController::API
  include ActionController::Cookies

  # リクエストを送ったユーザーの情報を設定
  def set_user
    unless @user ||= User.find_by(id: cookies[:id])
      render json: "Unauthorized", status: :unauthorized
    end
  end
end
