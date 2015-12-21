class SubscribersNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(question)
    question.followers.each do |user|
      SubscribersMailer.new_answer_notification(user, question).deliver_later
    end
  end
end
