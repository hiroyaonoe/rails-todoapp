class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  # ユーザーのトークンが一致するか検証する
  def authenticate_user
    authenticate_or_request_with_http_token do |token, options|
      auth_table = decode_token(token)
      @user ||= User.find_by(id: auth_table["id"])
      if @user.session_digest
        BCrypt::Password.new(@user.session_digest).
                         is_password?(auth_table["session_token"])
      end
    end
  end

  private 

    # 受け取ったトークンをデコードしてセッション用トークンとUserIDを返す
    def decode_token(joined_token)
      JSON.parse(Base64.decode64(CGI.unescape(joined_token)))
    end
end
