require "test_helper"

class Api::V1::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "login with valid information" do
    post api_v1_login_url params: {email: @user.email,
                                   password: 'password'}
    assert is_logged_in?
  end


end
