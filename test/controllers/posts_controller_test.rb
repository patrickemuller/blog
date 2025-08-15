require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = FactoryBot.create(:post)
    @admin = FactoryBot.create(:user, :admin)
  end

  test "should get index" do
    get posts_url
    assert_response :success
  end

  test "should get new when authenticated as admin" do
    login_as @admin
    get new_post_url
    assert_response :success
  end

  test "should redirect new when not authenticated" do
    get new_post_url
    assert_redirected_to new_user_session_path
  end

  test "should create post when authenticated as admin" do
    login_as @admin
    post_attributes = FactoryBot.attributes_for(:post)

    assert_difference("Post.count") do
      post posts_url, params: { post: post_attributes }
    end

    assert_redirected_to post_url(Post.last)
  end

  test "should redirect create when not authenticated" do
    post_attributes = FactoryBot.attributes_for(:post)

    assert_no_difference("Post.count") do
      post posts_url, params: { post: post_attributes }
    end

    assert_redirected_to new_user_session_path
  end

  test "should show post" do
    get post_url(@post)
    assert_response :success
  end

  test "should get edit when authenticated as admin" do
    login_as @admin
    get edit_post_url(@post)
    assert_response :success
  end

  test "should redirect edit when not authenticated" do
    get edit_post_url(@post)
    assert_redirected_to new_user_session_path
  end

  test "should update post when authenticated as admin" do
    login_as @admin
    updated_attributes = FactoryBot.attributes_for(:post)

    patch post_url(@post), params: { post: updated_attributes }
    assert_redirected_to post_url(@post)
  end

  test "should redirect update when not authenticated" do
    updated_attributes = FactoryBot.attributes_for(:post)

    patch post_url(@post), params: { post: updated_attributes }
    assert_redirected_to new_user_session_path
  end

  test "should destroy post when authenticated as admin" do
    login_as @admin
    assert_difference("Post.count", -1) do
      delete post_url(@post)
    end

    assert_redirected_to posts_url
  end

  test "should redirect destroy when not authenticated" do
    assert_no_difference("Post.count") do
      delete post_url(@post)
    end

    assert_redirected_to new_user_session_path
  end
end
