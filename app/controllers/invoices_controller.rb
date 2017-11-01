class InvoicesController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :set_invoice, only: [:show, :update, :destroy]

  def index
    authorize Invoice
    @month     = (params[:month] || Date.current.month).to_i
    date_range = current_catalog.date_range @month
    @invoices  = Invoice.where(date: date_range).order(number: :desc).page(params[:page]).all
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
    @invoice = InvoiceGenerator.call(generator_params)
  end

  def create
    authorize Invoice
    @invoice = InvoiceGenerator.call(generator_params)
    @invoice.assign_attributes invoice_params

    # @booking = Booking.find params[:booking_id]1

    if @invoice.save
      redirect_to seminar_path(@invoice.seminar, anchor: 'invoices'), notice: t(:created, model: Invoice.model_name.human)
    else
      render :new
    end
  end

  def update
    if @invoice.update invoice_params
      redirect_to seminar_path(@invoice.seminar, anchor: 'invoices'), notice: t(:updated, model: Invoice.model_name.human)
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
    permitted_params = %i[number date address pre_message post_message] + [items: %i[attendee price]]
    p = params.require(:invoice).permit(permitted_params)
    p[:items].delete_if { |item| item['attendee'].blank? }
    p[:items].each { |item| item['price'] = item['price'].delete('.').sub(',', '.').to_f }
    p
  end

  def generator_params
    return { attendee: Attendee.find(params[:attendee_id]) } if params[:attendee_id].present?
    { company: Company.find(params[:company_id]), seminar: Seminar.find(params[:seminar_id]) }
  end
end
