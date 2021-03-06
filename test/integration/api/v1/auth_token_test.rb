require "test_helper"

class Api::V1::AuthTokenTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @header = get_header_from_user(@user)
    @other_user = users(:two)
  end

  test "２度ログインしたら以前のトークンは無効になる" do
    old_header = @header
    @header = get_header_from_user(@user)
    get api_v1_user_url, headers: @header
    assert_response :ok
    get api_v1_user_url, headers: old_header
    assert_response :unauthorized
  end

  test "アクセストークン中のユーザーIDが改ざんされていればUnauthorized" do
    access_token = get_token_of(@user)
    access_table = decode_token(access_token)
    access_table["id"] = @other_user.id
    altered_token = encode_token(access_table)

    # other_userがトークンを発行していない場合
    get api_v1_user_url, headers: get_header_from_token(altered_token)
    assert_response :unauthorized

    # other_userがトークンを発行している場合
    other_token = get_token_of(@other_user)
    get api_v1_user_url, headers: get_header_from_token(altered_token)
    assert_response :unauthorized
  end

  test "アクセストークン中の認証トークンが改ざんされていればUnauthorized" do
    access_token = get_token_of(@user)
    access_table = decode_token(access_token)
    other_token = get_token_of(@other_user)
    other_table = decode_token(other_token)
    access_table["auth_token"] = other_table["auth_token"]
    altered_token = encode_token(access_table)

    get api_v1_user_url, headers: get_header_from_token(altered_token)
    assert_response :unauthorized
  end

  test "アクセストークン中の認証トークンがnilならばUnauthorized" do
    access_token = get_token_of(@user)
    access_table = decode_token(access_token)
    access_table.delete("auth_token")
    altered_token = encode_token(access_table)

    get api_v1_user_url, headers: get_header_from_token(altered_token)
    assert_response :unauthorized
  end

  test "アクセストークンの期限が切れているならばUnauthorized" do
    expired_user = users(:expired)
    access_table = { "id": expired_user.id, "auth_token": 'authenticate_token' }
    access_token = encode_token(access_table)
    expired_header = get_header_from_token(access_token)
    get api_v1_user_url, headers: expired_header
    assert_response :unauthorized
  end
end
