class ApplicationMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  default from: Setting.default_sender_email
  layout 'mailer'
end
