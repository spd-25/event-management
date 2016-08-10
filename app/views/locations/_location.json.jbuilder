json.extract! location, :id, :name, :short, :address, :created_at, :updated_at
json.url location_url(location, format: :json)