class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    User.find_each.each do |user|
      DailyMailer.digest(user).deliver_later
    end
  end
end
