json.extract! invoice, :id, :booking_id, :number, :date, :address, :pre_message, :post_message, :items, :status, :others, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)