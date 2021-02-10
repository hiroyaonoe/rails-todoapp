class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  # トークンに該当するユーザーを検索する
  def authenticate_user
    authenticate_or_request_with_http_token do |token, options|
      @user ||= User.find_by(session_token: token)
    end
  end
end
