class BuchungController < ApplicationController
  layout 'external'

  def new
    @seminar = Seminar.published.find params[:seminar_id]
    @booking = @seminar.bookings.build
    10.times { @booking.attendees.build }
  end

  def create
    @booking = Booking.new booking_params
    @booking.ip_address = request.remote_ip
    @booking.external = true
    copy_fields_to_attendees

    if @booking.save
      BookingMailer.booking_notification_email(@booking).deliver_later
      BookingMailer.booking_confirmation_email(@booking).deliver_later
      redirect_to buchung_show_url(@booking)
    else
      @seminar = Seminar.find @booking.seminar_id
      10.times { @booking.attendees.build }
      render :new
    end
  end

  def show
    @booking = Booking.find params[:booking_id]
    @seminar = @booking.seminar
  end

  private

  def copy_fields_to_attendees
    attributes = %w(seminar_id contact company_address invoice_address
                      member member_institution school year graduate comments)
    attributes = @booking.attributes.slice(*attributes)
    @booking.attendees.each { |attendee| attendee.assign_attributes attributes }
  end

  def booking_params
    attrs = [
      :seminar_id, :member, :member_institution, :graduate, :school, :year, :terms_of_service,
      :contact_email, :contact_phone, :contact_mobile, :contact_fax, :comments,
      :company_title, :company_street, :company_zip, :company_city,
      :invoice_title, :invoice_street, :invoice_zip, :invoice_city,
      attendees_attributes: %i(first_name last_name profession)
    ]
    p = params.require(:booking).permit(attrs)
    p['attendees_attributes'].reject! do |_, attr|
      attr['first_name'].blank? && attr['last_name'].blank?
    end
    p
  end
end
