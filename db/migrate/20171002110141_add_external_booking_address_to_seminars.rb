class AddExternalBookingAddressToSeminars < ActiveRecord::Migration[5.1]
  def change
    add_column :seminars, :external_booking_address, :string
  end
end
