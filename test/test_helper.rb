ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # ログインしてトークンを返す
  def get_token_of(user)
    post api_v1_login_path, params: { email: user.email,
      password: "password" }
    JSON.parse(@response.body)["token"]
  end

  # トークンをもとにAuthorizationヘッダーを返す
  def get_header_from_token(token)
    { "Authorization": "Token " << token }
  end

  # ログインしてAuthorizationヘッダーを返す
  def get_header_from_user(user)
    token = get_token_of(user)
    get_header_from_token(token)
  end

  # アクセストークンをデコードする
  def decode_token(access_token)
    JSON.parse(Base64.decode64(CGI.unescape(access_token)))
  end
  
  # ユーザーIDと認証トークンのハッシュテーブルをエンコードする
  def encode_token(access_table)
    CGI.escape(Base64.encode64(JSON.dump(access_table)))
  end
end
