json.extract! booking, :id, :seminar_id, :company, :invoice_address, :contact, :company_name, :places, :attendees, :created_at, :updated_at
json.url booking_url(booking, format: :json)