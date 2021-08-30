# frozen_string_literal: true

module Api
  module V1
    class PostResource < JSONAPI::Resource
      include ApplicationHelper

      model_name 'Post'
      primary_key :slug
      key_type :string

      attributes :slug, :title, :body, :striped_body, :created_at, :updated_at
    end
  end
end
