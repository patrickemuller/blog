# frozen_string_literal: true

class Post < ApplicationRecord
  validates :slug, :title, :body, presence: true
  validates :slug, uniqueness: { scope: :title }
end
