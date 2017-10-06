# Preview all emails at http://localhost:3000/rails/mailers/trello
class TrelloPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/trello/feedback_mail
  def feedback_mail
    TrelloMailer.feedback_mail Feedback.last.id
  end

end
