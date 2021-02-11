require "test_helper"

class Api::V1::TaskCrudTest < ActionDispatch::IntegrationTest
  setup do
    @task = tasks(:task1)
    @header = get_auth_header(@task.user)
  end

  test "should update, show, destroy, and create tasks" do
    # update
    put api_v1_task_url(@task), params: { title: "updated",
                                   content: "updated",
                                   is_completed: true,
                                   deadline: "2021-12-09" },
                                headers: @header
    assert_response :ok
    
    # show
    get api_v1_task_url(@task), headers: @header
    assert_response :ok
    res = JSON.parse(@response.body)
    assert_equal(8, res.length)
    assert_equal(@task.id, res["id"])
    assert_equal("updated", res["title"])
    assert_equal("updated", res["content"])
    assert_equal(true, res["is_completed"])
    assert_equal("2021-12-09", res["deadline"])
    
    # delete
    assert_difference('Task.count', -1) do
      delete api_v1_task_url(@task), headers: @header
    end
    assert_response :ok
    
    # create
    assert_difference('Task.count', 1) do
      post api_v1_tasks_url, params: { title: "title",
                                     content: "content",
                                     is_completed: false,
                                     deadline: "2021-02-09" },
                             headers: @header
    end
    assert_response :created
  end
end
