class RemoveCompanyFieldsFromBookings < ActiveRecord::Migration[5.0]
  def change
    remove_column :bookings, :company
    remove_column :bookings, :company_name
  end
end
