# Preview all emails at http://localhost:3000/rails/mailers/subscribers_mailer
class SubscribersMailerPreview < ActionMailer::Preview
  def new_answer_notification
    question = Answer.last
    SubscribersMailer.new_answer_notification question
  end
end
