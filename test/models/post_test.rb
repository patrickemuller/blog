require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "formatted_body leaves mermaid fences as escaped source for client-side rendering" do
    post = Post.new(body: <<~MARKDOWN)
      ```mermaid
      graph TD
        A["<b>Start</b>"] --> B
      ```
    MARKDOWN

    html = post.formatted_body

    assert_includes html, %(<pre class="mermaid">graph TD\n  A["&lt;b&gt;Start&lt;/b&gt;"] --&gt; B\n</pre>)
  end

  test "formatted_body still highlights other fenced languages" do
    post = Post.new(body: "```ruby\nputs 1\n```\n")

    assert_includes post.formatted_body, %(<pre class="highlight ruby">)
    assert_not_includes post.formatted_body, "mermaid"
  end

  test "formatted_body renders markdown tables but still strips table attributes" do
    post = Post.new(body: "| a | b |\n|---|--:|\n| 1 | 2 |\n")

    html = post.formatted_body

    assert_includes html, "<th>a</th>"
    assert_includes html, "<td>2</td>"
    assert_not_includes html, "style="
  end

  test "summary longer than 160 characters is invalid" do
    post = Post.new(title: "t", body: "b", summary: "x" * 161)

    assert_not post.valid?
    assert post.errors.of_kind?(:summary, :too_long)
  end
end
