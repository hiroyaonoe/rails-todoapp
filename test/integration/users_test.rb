require "test_helper"

class UsersTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should create, show, update, and destroy user" do
    assert_difference('User.count', 1) do
      post api_v1_users_url, params: {name: @user.name, email: @user.email, password: @user.password}, as: :json
    end
    assert_response 200

    get api_v1_user_url(@user), as: :json
    assert_response 200
    res = JSON.parse(response.body)
    assert_equal(3, res.length)
    assert_equal(@user.id, res[:id])
    assert_equal(@user.name, res[:name])
    assert_equal(@user.email, res[:email])
  end
end
