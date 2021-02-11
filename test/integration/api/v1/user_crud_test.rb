require "test_helper"

class Api::V1::UserCrudTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @header = get_auth_header(@user)
  end

  test "should update, show, destroy, and create user" do
    put api_v1_user_url, params: { name: "updated",
                                   email: "updated@email.com",
                                   password: "updated" },
                         headers: @header
    assert_response :ok

    get api_v1_user_url, headers: @header
    assert_response :ok
    res = JSON.parse(@response.body)
    assert_equal(3, res.length)
    assert_equal(@user.id, res["id"])
    assert_equal("updated", res["name"])
    assert_equal("updated@email.com", res["email"])
    
    assert_difference('User.count', -1) do
      delete api_v1_user_url, headers: @header
    end
    assert_response :ok

    assert_difference('User.count', 1) do
      post api_v1_user_url, params: {name: @user.name,
                                     email: @user.email,
                                     password: "password"}
    end
    assert_response :created
  end
end
