class SubscribersMailer < ApplicationMailer
  def new_answer_notification(answer)
    @greeting = "Hi"
    @question = answer.question
    @answer = answer

    mail to: @question.user.email
  end
end
