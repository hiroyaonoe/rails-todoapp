class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  # トークンに該当するユーザーを検索する
  def authenticate_user
    byebug
    authenticate_or_request_with_http_token do |token, options|
      @user ||= User.find_by(session_digest: User.digest(token)) # TODO: Tokenを認証するにはユーザーIDを先に知っていないといけない
    end
  end
end
