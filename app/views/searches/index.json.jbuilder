json.array!(@searches) do |search|
  json.extract! search, :id, :term
  json.url search_url(search, format: :json)
end
