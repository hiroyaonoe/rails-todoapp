require "test_helper"

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should create user" do
    assert_difference('User.count', 1) do
      post api_v1_users_url, params: {name: 'three', 
                                      email: 'example3@email.com', 
                                      password: 'password'}, as: :json
    end
    assert_response 201
  end

  test "should show user" do
    log_in_as(@user)
    get api_v1_user_url(@user), as: :json
    assert_response 200
    res = JSON.parse(response.body)
    assert_equal(3, res.length)
    assert_equal(@user.id, res[:id])
    assert_equal(@user.name, res[:name])
    assert_equal(@user.email, res[:email])
  end

  test "should update user" do
    patch api_v1_user_url(@user), params: {name: 'updated', 
                                           email: 'updated@email.com', 
                                           password: 'password'}, as: :json
    assert_response 200

    get api_v1_user_url(@user), as: :json
    assert_response 200
    res = JSON.parse(response.body)
    assert_equal(3, res.length)
    assert_equal('updated', res[:name])
    assert_equal('updated@email.com', res[:email])
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete api_v1_user_url(@user), as: :json
    end

    assert_response 204
  end
end
