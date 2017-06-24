class BookingMailer < ApplicationMailer
  add_template_helper ApplicationHelper
  add_template_helper SeminarsHelper

  def booking_confirmation_email(booking)
    @booking = booking
    @seminar = booking.seminar
    mail(to: booking.contact_email, subject: 'Paritätische Bildungswerk Sachsen-Anhalt - Seminaranmeldung')
  end

  def booking_notification_email(booking)
    @booking = booking
    @seminar = booking.seminar
    mail(to: Setting.new_booking_email, subject: 'Neue Seminaranmeldung')
  end
end
