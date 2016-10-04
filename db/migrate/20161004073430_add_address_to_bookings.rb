class AddAddressToBookings < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :address, :jsonb, default: '{}'
  end
end
