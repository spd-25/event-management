class AddFieldsToBookings < ActiveRecord::Migration[5.0]
  def change
    change_table :bookings do |t|
      t.boolean :member,             default: false
      t.boolean :member_institution, default: false
      t.boolean :graduate,           default: false
      t.string :school
      t.string :year
    end
  end
end
