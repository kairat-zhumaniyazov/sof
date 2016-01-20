class SubscribersMailer < ApplicationMailer
  def new_answer_notification(user, question)
    @greeting = 'Hi'
    @question = question

    mail to: user.email
  end
end
