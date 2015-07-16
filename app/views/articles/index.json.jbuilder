json.array!(@articles) do |article|
  json.extract! article, :id, :list_id, :name, :qty, :category, :type, :shop, :prize, :checked
  json.url article_url(article, format: :json)
end
