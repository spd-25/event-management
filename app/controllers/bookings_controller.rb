class BookingsController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]
  after_action :verify_authorized
  before_action :set_booking, only: [:show, :update, :destroy]
  layout :set_layout

  def index
    authorize Booking
    @bookings = Booking.includes(:seminar).order(created_at: :desc).all
  end

  def show
    prepare_attendees if @booking.company
  end

  def new
    authorize Booking
    @seminar = Seminar.find params[:seminar_id]
    @booking = @seminar.bookings.build
    # @booking.company = params[:company] == 'true'
    prepare_attendees
    # layout = user_signed_in? ? :default : 'old_site'
    # layout = :default
    # render layout: layout
  end

  def create
    authorize Booking
    @booking = Booking.new booking_params
    @booking.ip_address = request.remote_ip

    if @booking.save
      BookingMailer.booking_confirmation_email(@booking).deliver_later
      if user_signed_in?
        redirect_to @booking.seminar, notice: t(:created, model: Booking.model_name.human)
      else
        redirect_to seminar_visitor_url(@booking.seminar), notice: t('bookings.created')
      end
    else
      @seminar = Seminar.find @booking.seminar_id
      prepare_attendees if @booking.company
      render :new
    end
  end

  def update
    if @booking.update booking_params
      redirect_to @booking.seminar, notice: t(:updated, model: Booking.model_name.human)
    else
      render :show
    end
  end

  def destroy
    @booking.destroy
    redirect_to bookings_url, notice: t(:destroyed, model: Booking.model_name.human)
  end

  private

  def prepare_attendees
    10.times { @booking.attendees.build }
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_booking
    @booking = Booking.find params[:id]
    @seminar = @booking.seminar
    authorize @booking
  end

  # Only allow a trusted parameter "white list" through.
  def booking_params
    params.require(:booking).permit(:seminar_id, :company, :company_name, :invoice_address,
                                    :member, :member_institution, :graduate, :school, :year,
                                    :terms_of_service,
                                    :contact_person, :contact_email, :contact_phone, :contact_mobile,
                                    :contact_fax, :address_street, :address_zip, :address_city,
                                    attendees_attributes: %i(id first_name last_name profession _destroy) + [
                                      address: %i(street zip city),
                                      contact: %i(email phone mobile)
                                    ]
                                    )
  end

  def set_layout
    user_signed_in? ? 'application' : 'external'
  end
end
