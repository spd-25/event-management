class BookingMailer < ApplicationMailer

  def new_booking_email(booking)
    @booking = booking
    @seminar = booking.seminar
    mail(to: Setting.new_booking_email, subject: 'Neue Anmeldung')
  end

  def booking_confirmation_email(booking)
    @booking = booking
    @seminar = booking.seminar
    mail(to: booking.contact_email, subject: 'Paritätische Bildungswerk Sachsen-Anhalt - Seminaranmeldung')
  end
end
