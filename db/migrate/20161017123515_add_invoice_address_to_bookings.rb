class AddInvoiceAddressToBookings < ActiveRecord::Migration[5.0]
  def change
    remove_column :bookings, :invoice_address
    add_column :bookings, :company_address, :jsonb, default: '{}'
    add_column :bookings, :invoice_address, :jsonb, default: '{}'
  end
end
