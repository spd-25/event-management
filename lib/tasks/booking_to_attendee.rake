desc 'transfer booking related data to attendees'
task booking_to_attendees: :environment do
  puts
  attributes = %w(seminar_id company_id invoice_id contact company_address invoice_address
                  member member_institution school year graduate)
  Attendee.includes(:booking).all.each do |attendee|
    booking = attendee.booking
    attendee.update booking.attributes.slice(*attributes)
    attendee.canceled! if booking.canceled?
    print '.'
  end
  puts
end
