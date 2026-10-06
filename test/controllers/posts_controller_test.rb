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

  test "show emits escaped meta description from summary" do
    @post.update!(summary: %(Parsing "agent" output <safely>))

    get post_url(@post)

    assert_select %(meta[name="description"][content=?]), %(Parsing "agent" output <safely>)
    assert_select %(meta[property="og:description"])
  end

  test "show falls back to body excerpt for meta description without summary" do
    @post.update!(summary: nil, body: "First words of the post body.")

    get post_url(@post)

    assert_select %(meta[name="description"][content=?]), "First words of the post body."
  end

  test "show serves raw markdown via .md and Accept header" do
    @post.update!(title: "Q&A <tips>", summary: "Short & sweet", body: "## Heading\n\n```mermaid\nA --> B\n```")
    expected = "# Q&A <tips>\n\n> Short & sweet\n\n## Heading\n\n```mermaid\nA --> B\n```"

    get post_url(@post, format: :md)
    assert_equal "text/markdown", response.media_type
    assert_equal expected, response.body

    get post_url(@post), headers: { "Accept" => "text/markdown" }
    assert_equal "text/markdown", response.media_type
    assert_equal expected, response.body
    assert_includes response.headers["Vary"].to_s, "Accept"
  end

  test "show advertises the markdown alternate" do
    get post_url(@post)

    assert_select %(link[rel="alternate"][type="text/markdown"][href=?]), post_url(@post, format: :md)
  end

  test "llms.txt lists every post with an unescaped markdown link" do
    @post.update!(title: "Q&A <tips>", summary: "Short & sweet")

    get llms_txt_url

    assert_response :success
    assert_equal "text/markdown", response.media_type
    assert_includes response.body, "- [Q&A <tips>](#{post_url(@post, format: :md)}): Short & sweet"
  end

  test "post dates are not exposed on index, show, or JSON" do
    @post.update_columns(created_at: Time.utc(2024, 3, 7, 9), updated_at: Time.utc(2024, 3, 8, 9))

    [ posts_url, post_url(@post), posts_url(format: :json), post_url(@post, format: :json) ].each do |url|
      get url

      assert_response :success
      [ "2024-03-07", "2024-03-08", "March 7, 2024", "March 8, 2024" ].each do |date|
        assert_not_includes response.body, date, "#{url} exposes #{date}"
      end
    end
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
