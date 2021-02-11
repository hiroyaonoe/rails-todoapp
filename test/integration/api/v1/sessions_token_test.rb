require "test_helper"

class Api::V1::SessionsTokenTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "トークンを発行して削除が出来る" do
    post api_v1_login_url, params: { email: @user.email,
                                     password: "password" }
    assert_response :created

    delete api_v1_logout_url, 
           headers: { "Authorization": "Token " << @response.body }
    assert_response :ok
  end
end
