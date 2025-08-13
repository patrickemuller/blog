class Post < ApplicationRecord
  extend FriendlyId
  include ActionView::Helpers::SanitizeHelper

  friendly_id :title, use: :slugged

  searchkick word_start: [ :title, :body ],
             word_middle: [ :title, :body ]

  validates :title, :body, presence: true

  def formatted_body
    highlighted_body = Redcarpet::Markdown.new(::SyntaxHighlighting.new, {
      fenced_code_blocks: true
    }).render(body)

    sanitize(
      highlighted_body,
      tags: %w[h1 h2 h3 h4 h5 h6 p br strong em ul ol li blockquote pre code a span],
      attributes: %w[href class]
    )
  end
end
