class DailyMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_mailer.digest.subject
  #
  def digest(user)
    @greeting = 'Hi'
    @questions = Question.created_yesterday

    mail to: user.email
  end
end
