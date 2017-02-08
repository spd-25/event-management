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
    options = params[:attendee_id].present? ?
      { attendee: find_attendee } :
      { company: find_company, seminar: find_seminar }
    @invoice = InvoiceGenerator.new(options).invoice
    puts
  end

  def create
    authorize Invoice
    options = params[:attendee_id].present? ?
          { attendee: find_attendee } :
          { company: find_company, seminar: find_seminar }
    @invoice = InvoiceGenerator.new(options).invoice
    @invoice.assign_attributes invoice_params

    # @booking = Booking.find params[:booking_id]1

    if @invoice.save
      redirect_to @invoice.seminar, notice: t(:created, model: Invoice.model_name.human)
    else
      render :new
    end
  end

  def update
    if @invoice.update invoice_params
      redirect_to @invoice.seminar, notice: t(:updated, model: Invoice.model_name.human)
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
    authorize @invoice
  end

  # Only allow a trusted parameter "white list" through.
  def invoice_params
    p = params.require(:invoice).permit(:number, :date, :address,
                                        :pre_message, :post_message,
                                        items: [:attendee, :price])
    p[:items].each { |item| item['price'] = item['price'].gsub('.', '').sub(',', '.').to_f }
    p
  end

  def find_attendee
    Attendee.find params[:attendee_id]
  end

  def find_company
    Company.find params[:company_id]
  end

  def find_seminar
    Seminar.find params[:seminar_id]
  end
end
