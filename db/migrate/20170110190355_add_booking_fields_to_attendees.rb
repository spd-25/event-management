class AddBookingFieldsToAttendees < ActiveRecord::Migration[5.0]
  def change
    change_table :attendees do |t|
      t.boolean :member
      t.boolean :member_institution
      t.boolean :graduate
      t.string :school
      t.string :year
      t.jsonb :company_address, default: '{}'
      t.jsonb :invoice_address, default: '{}'
    end
  end
end
