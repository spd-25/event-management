class InvoicesController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :set_invoice, only: [:show, :update, :destroy]

  def index
    authorize Invoice
    @invoices = Invoice.all
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        pdf = InvoicePdf.new(@invoice)
        send_data pdf.render, filename: pdf.filename, type: 'application/pdf', disposition: 'inline'
      end
    end
  end

  def new
    authorize Invoice
    @booking = Booking.find params[:booking_id]
    @invoice = @booking.generate_invoice
  end

  def create
    authorize Invoice
    @booking = Booking.find params[:booking_id]
    @invoice = Invoice.new invoice_params
    @invoice.booking = @booking

    if @invoice.save
      redirect_to @booking.seminar, notice: t(:created, model: Invoice.model_name.human)
    else
      render :new
    end
  end

  def update
    if @invoice.update invoice_params
      redirect_to @booking.seminar, notice: t(:updated, model: Invoice.model_name.human)
    else
      render :show
    end
  end

  def destroy
    @invoice.destroy
    redirect_to invoices_url, notice: t(:destroyed, model: Invoice.model_name.human)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_invoice
    @invoice = Invoice.find params[:id]
    @booking = @invoice.booking
    authorize @invoice
  end

  # Only allow a trusted parameter "white list" through.
  def invoice_params
    p = params.require(:invoice).permit(:booking_id, :number, :date, :address,
                                        :pre_message, :post_message,
                                        items: [:attendee, :price])
    p[:items].each { |item| item['price'] = item['price'].sub(',', '.').to_f }
    p
  end
end
