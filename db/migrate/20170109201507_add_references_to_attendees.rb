class AddReferencesToAttendees < ActiveRecord::Migration[5.0]
  def change
    add_reference :attendees, :company, foreign_key: true
    add_reference :attendees, :invoice, foreign_key: true
  end
end
