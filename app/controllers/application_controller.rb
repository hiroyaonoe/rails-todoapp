class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  # ユーザーのトークンが有効か検証し，権限がなければエラーを返す
  def authenticate
    authenticate_token || unauthorized_response
  end

  # エラー用のJSONとステータスコードを返す
  def error_response(status, message)
    render json: { status: status, error: message }, status: status
  end

  private

  # ユーザーのトークンが有効か検証する
    def authenticate_token
      authenticate_with_http_token do |token, options|
        user_id, auth_token = User.decode_token(token)
        @user ||= User.find_by(id: user_id)
        @user && @user.authenticated?(auth_token) && !@user.token_expired?
      end
    end

    # 権限がなかったときのエラーを返す
    def unauthorized_response
      message = "HTTP Token: Access denied."
      headers["WWW-Authenticate"] = %(Token realm="Application")
      error_response(:unauthorized, message)
    end
end
