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

  describe '#subscribe' do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }

    context 'not subscribed user' do
      it 'should create subscription' do
        expect { question.subscribe(user) }.to change(question.followers, :count).by(1)
      end
    end

    context 'already subscribed user' do
      before { question.followers << user }
      it 'should not create Subscription' do
        expect { question.subscribe(user) }.to_not change(Subscription, :count)
      end
    end
  end

  describe '#unsubscribe' do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }

    context 'already subscribed user' do
      before { question.followers << user }
      it 'should destroy subscription' do
        expect { question.unsubscribe(user) }.to change(question.followers, :count).by(-1)
      end
    end

    context 'non subscribed user' do
      it 'should not change subscription count' do
        expect { question.unsubscribe(user) }.to_not change(Subscription, :count)
      end
    end
  end

  describe 'calculate_reputation' do
    context 'when vote for question' do
      let(:user) { create(:user) }
      let!(:author) { create(:user) }
      let!(:question) { create(:question, user: author) }

      context 'voting PLUS' do
        subject { question.make_vote(1, user) }

        it 'should add reputation 1 times' do
          expect(ReputationCalculator).to receive(:calculate).with(:vote, question, user, value: 1).once
          subject
        end

        it 'should change reputation for answer author' do
          expect { subject }.to change{author.reputation}.by(2)
        end
      end

      context 'voting MINUS' do
        subject { question.make_vote(-1, user) }

        it 'should add reputation 1 times' do
          expect(ReputationCalculator).to receive(:calculate).with(:vote, question, user, value: -1).once
          subject
        end

        it 'should change reputation for answer author' do
          expect { subject }.to change{author.reputation}.by(-2)
        end
      end
    end
  end

  it_behaves_like 'taggable'
end
