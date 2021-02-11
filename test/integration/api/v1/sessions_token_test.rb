require "test_helper"

class Api::V1::SessionsTokenTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @task = tasks(:task1)
  end

  test "トークンを発行して削除が出来る" do
    post api_v1_login_url, params: { email: @user.email,
                                     password: "password" }
    assert_response :created
    res = JSON.parse(@response.body)
    assert_equal(1, res.length)

    token = res["token"]
    delete api_v1_logout_url, 
           headers: { "Authorization": "Token " << token }
    assert_response :ok
    get api_v1_user_url, headers: { "Authorization": "Token " << token }
    assert_response :unauthorized
  end

  test "トークンを付与していなければusers#create,session#create以外はUnauthorized" do
    # session
    delete api_v1_logout_url
    assert_response :unauthorized
    
    # user
    put api_v1_user_url, params: { name: "updated",
                                   email: "updated@email.com",
                                   password: "updated" }
    assert_response :unauthorized

    get api_v1_user_url
    assert_response :unauthorized

    assert_difference('User.count', 0) do
      delete api_v1_user_url
    end
    assert_response :unauthorized

    # task
    put api_v1_task_url(@task), params: { title: "updated",
                                          content: "updated",
                                          is_completed: true,
                                          deadline: "2021-12-09" }
    assert_response :unauthorized

    get api_v1_task_url(@task)
    assert_response :unauthorized

    assert_difference('Task.count', 0) do
      delete api_v1_task_url(@task)
    end
    assert_response :unauthorized

    assert_difference('Task.count', 0) do
      post api_v1_tasks_url, params: { title: "title",
            content: "content",
            is_completed: false,
            deadline: "2021-02-09" }
    end
    assert_response :unauthorized
  end
end
