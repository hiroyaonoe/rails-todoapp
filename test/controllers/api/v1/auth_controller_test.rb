require "test_helper"

class Api::V1::AuthControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @header = get_auth_header(@user)
  end

  test "２度ログインしたら以前のトークンは無効になる" do
    old_header = @header
    @header = get_auth_header(@user)
    get api_v1_user_url, headers: @header
    assert_response :ok
    get api_v1_user_url, headers: old_header
    assert_response :unauthorized
  end
end
