class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  # ユーザーのトークンが一致するか検証する
  def authenticate_user
    authenticate_or_request_with_http_token do |token, options|
      user_id, auth_token = User.decode_token(token)
      @user ||= User.find_by(id: user_id)
      if @user && @user.auth_digest
        BCrypt::Password.new(@user.auth_digest).is_password?(auth_token)
      end
    end
  end
end
