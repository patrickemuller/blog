# frozen_string_literal: true

class Post < ApplicationRecord
  include ApplicationHelper

  validates :slug, :title, :body, presence: true
  validates :slug, uniqueness: { scope: :title }

  before_save :populate_striped_body

  def populate_striped_body
    striped_text = ActionController::Base.helpers.truncate(
      ActionController::Base.helpers.strip_tags(
        convert_to_markdown(body)
      ),
      length: 140
    )

    self.striped_body = striped_text
  end
end
