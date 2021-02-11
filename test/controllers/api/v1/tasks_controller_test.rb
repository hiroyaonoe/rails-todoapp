require "test_helper"

class Api::V1::TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @header = get_header_from_user(@user)
  end

  test "検索範囲の開始を指定して検索" do
    get api_v1_tasks_url, params: { start: "2021-02-11" }, headers: @header
    assert_response :ok
    res = JSON.parse(@response.body)
    assert_equal(6, res.length)
  end

  test "検索範囲の終了を指定して検索" do
    get api_v1_tasks_url, params: { end: "2021-02-11" }, headers: @header
    assert_response :ok
    res = JSON.parse(@response.body)
    assert_equal(7, res.length)
  end

  test "完了しているタスクを指定して検索" do
    get api_v1_tasks_url, params: { iscomp: true }, headers: @header
    assert_response :ok
    res = JSON.parse(@response.body)
    assert_equal(5, res.length)
  end

  test "完了していないタスクを指定して検索" do
    get api_v1_tasks_url, params: { iscomp: false }, headers: @header
    assert_response :ok
    res = JSON.parse(@response.body)
    assert_equal(6, res.length)
  end

  test "複数の条件を指定して検索" do
    get api_v1_tasks_url, params: { start: "2021-02-11",
                                    end: "2021-02-11",
                                    iscomp: true }, 
                          headers: @header
    assert_response :ok
    res = JSON.parse(@response.body)
    assert_equal(1, res.length)
  end
end
