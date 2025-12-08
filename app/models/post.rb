class Post < ApplicationRecord
  extend FriendlyId
  include ActionView::Helpers::SanitizeHelper

  friendly_id :title, use: :slugged

  validates :title, :body, presence: true

  # PostgreSQL full-text search
  def self.search(query)
    if query.blank?
      all
    else
      # For short queries or numeric queries, use ILIKE for substring matching
      # to match word_start and word_middle behavior from Searchkick
      if query.length <= 3 || query.match?(/^\d+$/)
        where("title ILIKE ? OR body ILIKE ?", "%#{sanitize_sql_like(query)}%", "%#{sanitize_sql_like(query)}%")
          .order(created_at: :desc)
      else
        # Use full-text search for longer queries with relevance ranking
        where("search_vector @@ plainto_tsquery('english', ?)", query)
          .order(Arel.sql("ts_rank(search_vector, plainto_tsquery('english', #{connection.quote(query)})) DESC"))
      end
    end
  end

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
