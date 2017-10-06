# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TrelloMailer, type: :mailer do
  describe 'feedback' do
    let(:feedback) { create :feedback }
    let(:mail) { TrelloMailer.feedback_mail(feedback.id) }

    it 'renders the headers' do
      expect(mail.subject).to eq(feedback.subject)
      expect(mail.to).to eq([Setting.trello_board_email])
      expect(mail.from).to eq([Setting.default_sender_email])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(feedback.path)
      expect(mail.body.encoded).to match(feedback.message)
      expect(mail.body.encoded).to match(feedback.user.name)
    end
  end
end
