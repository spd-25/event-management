class BookingReferencesToAttendees < ActiveRecord::Migration[5.0]
  def up
    Attendee.includes(:booking).all.each do |attendee|
      booking = attendee.booking
      attendee.seminar_id = booking.seminar_id
      attendee.company_id = booking.company_id
      attendee.invoice_id = booking.invoice_id
      attendee.save!
      attendee.canceled! if booking.canceled?
    end
  end

  def down
    Attendee.update_all seminar_id: nil, company_id: nil, invoice_id: nil, status: 0
  end
end
