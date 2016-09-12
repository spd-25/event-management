class AddInvoiceIdToBookings < ActiveRecord::Migration[5.0]
  def change
    add_reference :bookings, :invoice, foreign_key: true
  end
end
