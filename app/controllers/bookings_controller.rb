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
    10.times { @booking.attendees.build }
  end

  def edit
    10.times { @booking.attendees.build }
  end

  def create
    authorize Booking
    @booking = Booking.new booking_params

    if @booking.save
      redirect_to @booking, notice: t(:created, model: Booking.model_name.human)
    else
      10.times { @booking.attendees.build }
      render :new
    end
  end

  def update
    if @booking.update booking_params
      redirect_to @booking, notice: t(:updated, model: Booking.model_name.human)
    else
      10.times { @booking.attendees.build }
      render :edit
    end
  end

  def destroy
    @booking.destroy
    redirect_to bookings_url, notice: t(:destroyed, model: Booking.model_name.human)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_booking
    @booking = Booking.find params[:id]
    authorize @booking
  end

  # Only allow a trusted parameter "white list" through.
  def booking_params
    p                        = params.require(:booking).permit(:seminar_id, :company, :company_name,
                                    attendees_attributes: %i(id first_name last_name profession) + [
                                      address: %i(street zip city),
                                      contact: %i(email phone mobile)
                                    ],
                                    invoice_address: %i(street zip city),
                                    contact: %i(email phone mobile))
    p[:attendees_attributes] = p[:attendees_attributes].slice('0') if p[:company] == '0'
    p
  end
end
