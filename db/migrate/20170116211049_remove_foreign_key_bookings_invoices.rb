class RemoveForeignKeyBookingsInvoices < ActiveRecord::Migration[5.0]
  def up
    remove_foreign_key :bookings, :invoices
    remove_index :bookings, :invoice_id
  end

  def down
    add_index :bookings, :invoice_id
    add_foreign_key :bookings, :invoices
  end
end
