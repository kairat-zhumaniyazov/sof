require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:voteable) }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :value }
  it { should validate_presence_of :voteable_id }

  describe 'votes sum' do
    context 'for question' do
      let(:question) { create(:question) }

      context 'new vote' do
        subject { question.votes.create(user: create(:user), voteable: question, value: 1) }

        it 'should call votes calculator' do
          expect(VotesCalculator).to receive(:calculate_for).with(question, 1)
          subject
        end

        it 'should change votes sum for question' do
          subject
          question.reload
          expect(question.votes_sum).to eq 1
        end

        it 'should change votes count' do
          expect{ subject }.to change(question.votes, :count).by(1)
        end
      end

      context 'destroy vote' do
        let!(:vote) { create(:vote, user: create(:user), voteable: question, value: 1) }
        subject { vote.destroy }

        it 'should call votes caclulator' do
          expect(VotesCalculator).to receive(:calculate_for).with(question, -1)
          subject
        end

        it 'should change votes sum for Question' do
          subject
          question.reload
          expect(question.votes_sum).to eq 0
        end

        it 'should change votes count' do
          expect{ subject }.to change(question.votes, :count).by(-1)
        end
      end
    end


    context 'for answer' do
      let(:answer) { create(:answer) }

      context 'new vote' do
        subject { answer.votes.create(user: create(:user), voteable: answer, value: 1) }

        it 'should call votes calculator' do
          expect(VotesCalculator).to receive(:calculate_for).with(answer, 1)
          subject
        end

        it 'should change votes sum for answer' do
          subject
          answer.reload
          expect(answer.votes_sum).to eq 1
        end

        it 'should change votes count' do
          expect{ subject }.to change(answer.votes, :count).by(1)
        end
      end

      context 'destroy vote' do
        let!(:vote) { create(:vote, user: create(:user), voteable: answer, value: 1) }
        subject { vote.destroy }

        it 'should call votes caclulator' do
          expect(VotesCalculator).to receive(:calculate_for).with(answer, -1)
          subject
        end

        it 'should change votes sum for answer' do
          subject
          answer.reload
          expect(answer.votes_sum).to eq 0
        end

        it 'should change votes count' do
          expect{ subject }.to change(answer.votes, :count).by(-1)
        end
      end
    end
  end
end
