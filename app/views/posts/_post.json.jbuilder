json.extract! post, :id, :slug, :title, :body
json.url post_url(post, format: :json)
