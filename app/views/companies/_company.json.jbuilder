json.extract! company, :id, :code, :name, :name2, :street, :zip, :city, :city_part, :phone, :mobile, :fax, :email, :created_at, :updated_at
json.url company_url(company, format: :json)