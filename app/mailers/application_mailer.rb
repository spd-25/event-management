class ApplicationMailer < ActionMailer::Base
  default from: Setting.default_sender_email
  layout 'mailer'
end
