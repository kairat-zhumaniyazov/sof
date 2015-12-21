require 'rails_helper'

RSpec.describe SubscribersNotificationJob, type: :job do
  let(:users) { create_list(:user, 2) }
  let(:question) { create(:question, followers: users) }

  it 'should send notification for all followers' do
    question.followers.each { |user| expect(SubscribersMailer).to receive(:new_answer_notification).with(user, question).and_call_original }
    SubscribersNotificationJob.perform_now(question)
  end
end
