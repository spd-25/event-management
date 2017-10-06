class TrelloMailer < ApplicationMailer
  def feedback_mail(feedback_id)
    @feedback = Feedback.find feedback_id
    mail to: Setting.trello_board_email, subject: @feedback.subject
  end
end
