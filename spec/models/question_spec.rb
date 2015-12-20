require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }

  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:followers).through(:subscriptions).source(:user) }

  it_behaves_like 'voteable'
  it_behaves_like 'commentable'
  it_behaves_like 'Attachable'

  describe 'created_yesterday scope' do
    let!(:old_questions) { create_list(:question, 3, created_at: 2.days.ago) }
    let!(:yesterdays_questions) { create_list(:question, 3, created_at: 1.day.ago) }
    subject { Question.created_yesterday }

    it { should eq yesterdays_questions }
  end
end
