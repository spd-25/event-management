class FeedbacksController < ApplicationController
  before_action :authenticate_user!

  def new
    @feedback = Feedback.new path: request.referer
    render layout: !request.xhr?
  end

  def create
    @feedback = Feedback.new feedback_params
    @feedback.user = current_user
    if @feedback.save
      TrelloMailer.feedback_mail(@feedback.id).deliver_later
      render json: {}, status: 200
    else
      render :new, layout: false, status: :unprocessable_entity
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit :subject, :message, :path
  end
end
