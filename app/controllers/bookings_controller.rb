class BookingsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :set_booking, only: [:show, :edit, :update, :destroy]

  def index
    authorize Booking
    @bookings = Booking.includes(:seminar).order(created_at: :desc).all
  end

  def show
  end

  def new
    authorize Booking
    @seminar = Seminar.find params[:seminar_id]
    @booking = @seminar.bookings.build
    @booking.company = params[:company] == 'true'
    prepare_attendees
  end

  def edit
    prepare_attendees if @booking.company
  end

  def create
    authorize Booking
    @booking = Booking.new booking_params

    if @booking.save
      redirect_to @booking, notice: t(:created, model: Booking.model_name.human)
    else
      prepare_attendees
      render :new
    end
  end

  def update
    if @booking.update booking_params
      redirect_to @booking, notice: t(:updated, model: Booking.model_name.human)
    else
      prepare_attendees
      render :edit
    end
  end

  def destroy
    @booking.destroy
    redirect_to bookings_url, notice: t(:destroyed, model: Booking.model_name.human)
  end

  private

  def prepare_attendees
    (@booking.company ? 10 : 1).times { @booking.attendees.build }
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_booking
    @booking = Booking.find params[:id]
    authorize @booking
  end

  # Only allow a trusted parameter "white list" through.
  def booking_params
    params.require(:booking).permit(:seminar_id, :company, :company_name,
                                    attendees_attributes: %i(id first_name last_name profession) + [
                                      address: %i(street zip city),
                                      contact: %i(email phone mobile)
                                    ],
                                    invoice_address: %i(street zip city),
                                    contact: %i(email phone mobile))
  end
end
