class AttendeesController < ApplicationController
  before_action :authenticate_user!
   after_action :verify_authorized
   before_action :set_attendee, only: [:show, :update, :destroy, :cancel]
   before_action :set_referer, only: [:show, :cancel]

   def index
     authorize Attendee
     @attendees = Attendee.booked.includes(:seminar).order(created_at: :desc).page(params[:page]).all
   end

   def show
   end

   def cancel
   end

   def update
     if @attendee.update attendee_params
       redirect_to (session[:back_url] || @attendee.seminar), notice: t(:updated, model: Attendee.model_name.human)
     else
       render :show
     end
   end

   def destroy
     @attendee.canceled!
     redirect_to (session[:back_url] || @attendee.seminar), notice: t('attendees.cancel.notice')
   end

   private

   # Use callbacks to share common setup or constraints between actions.
   def set_attendee
     @attendee = Attendee.find(params[:id] || params[:attendee_id])
     @seminar = @attendee.seminar
     authorize @attendee
   end

   # Only allow a trusted parameter "white list" through.
   def attendee_params
     attrs = %i(first_name last_name
       member member_institution graduate school year terms_of_service
       contact_person contact_email contact_phone contact_mobile contact_fax comments
       company_title company_street company_zip company_city company_id
       invoice_title invoice_street invoice_zip invoice_city
     )
     params.require(:attendee).permit(attrs)
   end

   def set_referer
     session[:back_url] = request.referer
   end
end

