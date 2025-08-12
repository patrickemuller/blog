json.extract! post, :id, :slug, :title, :body, :created_at, :updated_at
json.url post_url(post, format: :json)
