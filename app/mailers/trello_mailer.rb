class TrelloMailer < ApplicationMailer
  def feedback_mail(feedback_id)
    @feedback = Feedback.find feedback_id
    subject   = "#{@feedback.user.name}: #{@feedback.subject}"

    mail to: Setting.trello_board_email, bcc: Setting.developer_email, subject: subject
  end
end
