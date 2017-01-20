class AddCommentsToBookings < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :comments, :text
  end
end
