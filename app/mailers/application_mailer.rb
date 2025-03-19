# frozen_string_literal: true

# main mailer of app
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
