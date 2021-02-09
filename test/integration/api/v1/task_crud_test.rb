require "test_helper"

class Api::V1::TaskCrudTest < ActionDispatch::IntegrationTest
  setup do
    @task = tasks(:task1)
  end

  test "should update, show, destroy, and create tasks" do
    log_in_as(@task.user_id)

    # update
    put api_v1_task_url(@task), params: { title: "updated",
                                   content: "updated",
                                   is_completed: true,
                                   deadline: "2021-12-09" }
    assert_response :ok
    
    # show
    get api_v1_task_url(@task)
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
      delete api_v1_task_url(@task)
    end
    assert_response :ok
    
    # create
    assert_difference('Task.count', 1) do
      post api_v1_tasks_url, params: { title: "title",
                                     content: "content",
                                     is_completed: false,
                                     deadline: "2021-02-09" }
    end
    assert_response :created
  end
end
