# Preview all emails at http://localhost:3000/rails/mailers/booking_mailer
class BookingMailerPreview < ActionMailer::Preview
  def booking_confirmation_email
    BookingMailer.booking_confirmation_email(Booking.last)
  end
end
