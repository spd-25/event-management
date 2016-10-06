class AddIpAddressToBookings < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :ip_address, :string
  end
end
