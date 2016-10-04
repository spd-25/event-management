class BookingMailer < ApplicationMailer

  def new_booking_email(booking)
    @booking = booking
    mail(to: Setting.new_booking_email, subject: 'Neu Anmeldung')
  end
end
