require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:question) { create(:question) }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }

  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it_behaves_like 'voteable'
  it_behaves_like 'commentable'
  it_behaves_like 'Attachable'

  describe '#make_best' do
    let(:user) { create(:user) }
    let!(:answers) { create_list(:answer, 3, question: question, best: true) }
    let!(:best_answer) { create(:answer, question: question, best: false, user: user) }

    it 'should change :best' do
      best_answer.make_best
      best_answer.reload
      expect(best_answer.best).to be true
    end

    it 'should change other answer :best attr' do
      best_answer.make_best
      answers.each do |answer|
        answer.reload
        expect(answer.best).to_not be true
      end
    end

    context 'best answers user reputation' do
      it 'should add reputation' do
        expect(ReputationCalculator).to receive(:calculate).with(:best_answer, best_answer, best_answer.user).once
        best_answer.make_best
      end

      it 'should have right reputation value' do
        expect { best_answer.make_best }.to change{best_answer.user.reputation}.by(3)
      end
    end
  end

  describe 'Ordering by best attr' do
    let!(:answers) { create_list(:answer, 5, question: question) }
    let!(:best_answer) { create(:answer, question: question, best: true) }

    it 'first answer in list have best attr eq true' do
      expect(question.answers.first).to eq best_answer
    end
  end

  describe 'email notification for new answer' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'when create should send email' do
      expect(SubscribersNotificationJob).to receive(:perform_later).with(question)
      Answer.create!(attributes_for(:answer).merge(question: question, user: create(:user)))
    end
  end

  describe 'calculate_reputation' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    context 'for another users question' do
      let(:question) { create(:question, user: another_user) }
      subject { Answer.create!(attributes_for(:answer).merge(question: question, user: user)) }

      context 'when first answer' do
        it 'should add reputation 2 times' do
          expect(ReputationCalculator).to receive(:calculate).with(:new_answer, Answer, user).once
          subject
        end

        it 'should have right repitation value' do
          expect { subject }.to change{user.reputation}.by(2)
        end
      end

      context 'when NOT first answer' do
        let!(:first_answer) { create(:answer, question: question) }

        it 'should add reputation once' do
          expect(ReputationCalculator).to receive(:calculate).with(:new_answer, Answer, user).once
          subject
        end

        it 'should have right reputation value' do
          expect { subject }.to change{user.reputation}.to(1)
        end
      end
    end

    context 'for own question' do
      let(:question) { create(:question, user: user) }
      subject { Answer.create!(attributes_for(:answer).merge(question: question, user: user)) }

      context 'when first answer' do
        it 'should add reputation 3 times' do
          expect(ReputationCalculator).to receive(:calculate).with(:new_answer, Answer, user).once
          subject
        end

        it 'should have right reputation value' do
          expect { subject }.to change{user.reputation}.to(4)
        end
      end

      context 'when NOT first answer' do
        let!(:first_answer) { create(:answer, question: question) }

        it 'should add reputation 2 times' do
          expect(ReputationCalculator).to receive(:calculate).with(:new_answer, Answer, user).once
          subject
        end

        it 'should have right repitation value' do
          expect { subject }.to change{user.reputation}.to(3)
        end
      end
    end

    context 'when vote for answer' do
      let(:user) { create(:user) }
      let!(:author) { create(:user) }
      let!(:answer) { create(:answer, user: author) }

      context 'voting PLUS' do
        subject { answer.make_vote(1, user) }

        it 'should add reputation 1 times' do
          expect(ReputationCalculator).to receive(:calculate).with(:vote, answer, user, value: 1).once
          subject
        end

        it 'should change reputation for answer author' do
          expect { subject }.to change{author.reputation}.by(1)
        end
      end

      context 'voting MINUS' do
        subject { answer.make_vote(-1, user) }

        it 'should add reputation 1 times' do
          expect(ReputationCalculator).to receive(:calculate).with(:vote, answer, user, value: -1).once
          subject
        end

        it 'should change reputation for answer author' do
          expect { subject }.to change{author.reputation}.by(-1)
        end
      end
    end
  end
end
