class Post < ApplicationRecord
  extend FriendlyId

  friendly_id :title, use: :slugged

  validates :title, :body, presence: true

  def formatted_body
    Redcarpet::Markdown.new(::SyntaxHighlighting.new, {
      fenced_code_blocks: true
    }).render(body)
  end
end
