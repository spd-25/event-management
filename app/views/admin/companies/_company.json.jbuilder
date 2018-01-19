json.extract! company, :id, :name, :name2, :street, :zip, :city, :city_part, :phone, :mobile, :fax, :email, :created_at, :updated_at
json.url admin_company_url(company, format: :json)
