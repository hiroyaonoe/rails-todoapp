class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  # ユーザーのトークンが一致するか検証する
  def authenticate_user
    authenticate_or_request_with_http_token do |token, options|
      user_id, auth_token = decode_token(token)
      @user ||= User.find_by(id: user_id)
      if @user.auth_digest
        BCrypt::Password.new(@user.auth_digest).is_password?(auth_token)
      end
    end
  end

  private 

    # 受け取ったアクセストークンをデコードして認証トークンとUserIDを返す
    def decode_token(access_token)
      access_table = JSON.parse(Base64.decode64(CGI.unescape(access_token)))
      return access_table["id"], access_table["auth_token"]
    end
end
