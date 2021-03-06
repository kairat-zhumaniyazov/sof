require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe "POST :create" do
    sign_in_user

    context "with valid params" do
      subject { post :create, question_id: question, answer: attributes_for(:answer), format: :js }

      it 'should be right question' do
        subject
        expect(assigns(:question)).to eq question
      end

      it 'should create new answer for question' do
        expect { subject }.to change(question.answers, :count).by(1)
      end
      it 'should render :create template' do
        subject
        expect(response).to render_template :create
      end

      it 'should have right answer owner' do
        expect { subject }.to change(@user.answers, :count).by(1)
      end

      it_behaves_like 'Publishable' do
        let(:channel) { "/questions/#{question.id}/answers" }
      end
    end

    context 'with invalid params' do
      subject { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }

      it 'should not create new answer' do
        expect { subject }.to_not change(Answer, :count)
      end
      it 'should render :create template' do
        subject
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, question_id: answer.question, id: answer, format: :js }
    let!(:answer) { create(:answer, user: user, question: question) }

    context 'signed in user' do
      before { sign_in user }

      it 'should delete answer' do
        expect { subject }.to change(Answer, :count).by(-1)
      end
      it 'should redirect to question show page' do
        subject
        expect(response).to render_template :destroy
      end
    end

    context 'non-signed in user' do
      it 'should not delete answer' do
        expect { subject }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    subject { patch :update, question_id: question, id: answer, answer: { body: 'updated body' }, format: :js }
    let(:answer) { create(:answer, user: user, question: question) }

    before do
      sign_in user
      subject
    end

    it 'should be right question' do
      expect(assigns(:question)).to eq question
    end
    it 'should be right answer' do
      expect(assigns(:answer)).to eq answer
    end
    it 'should change answer' do
      answer.reload
      expect(answer.body).to eq 'updated body'
    end
    it 'should render update template' do
      expect(response).to render_template :update
    end
  end

  describe 'POST #best_answer' do
    subject { post :best_answer, id: answer, question_id: question, format: :js }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question) }

    context 'Question author' do

      before do
        sign_in user
        subject
      end

      it 'should have right question' do
        expect(assigns(:question)).to eq question
      end

      it 'should have right answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'should change best status' do
        answer.reload
        expect(answer.best).to be true
      end

      context 'with answers list' do
        let!(:answer_1) { create(:answer, question: question, best: true) }
        let!(:answer_2) { create(:answer, question: question) }

        it 'should change best attr for answer_1' do
          post :best_answer, id: answer_2, question_id: question, format: :js
          answer_1.reload
          answer.reload
          expect(answer_1.best).to_not be true
          expect(answer.best).to_not be true
        end
      end
    end

    context 'Not question author' do
      before { sign_in another_user }
      it 'should not change best attr' do
        subject
        answer.reload
        expect(answer.best).to_not be true
      end
    end
  end

  describe 'POST #vote_plus' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:another_answer) { create(:answer, question: question) }

    before { sign_in user }
    context 'not answer autor can vote for Answer' do
      subject { post :vote_plus, question_id: question, id: another_answer }

      it 'should change Votes count' do
        expect { subject }.to change(another_answer.votes, :count).by(1)
      end

      it 'should have votes sum' do
        subject
        another_answer.reload
        expect(another_answer.votes_sum).to eq 1
      end

      context 'double vote' do
        before { subject }
        it 'should not change Votes count' do
          expect { subject }.to_not change(another_answer.votes, :count)
        end
      end

      context 're-vote' do
        let!(:vote) { create(:vote_for_answer, user: user, voteable: another_answer, value: -1) }
        it 'should not change Votes count' do
          expect { subject }.to_not change(another_answer.votes, :count)
        end

        it 'should change vote.value' do
          subject
          vote.reload
          expect(vote.value).to eq 1
        end
      end
    end

    context 'answer author can not vote for Answer' do
      subject { post :vote_plus, question_id: question, id: answer }
      it 'should not change Votes count' do
        expect { subject }.to_not change(Vote, :count)
      end

      it 'should have votes sum' do
        subject
        expect(another_answer.votes_sum).to eq 0
      end
    end
  end

  describe 'POST #vote_minus' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:another_answer) { create(:answer, question: question) }

    before { sign_in user }
    context 'not answer autor can vote for Answer' do
      subject { post :vote_minus, question_id: question, id: another_answer }
      it 'should change Votes count' do
        expect { subject }.to change(another_answer.votes, :count).by(1)
      end

      it 'should have votes sum' do
        subject
        another_answer.reload
        expect(another_answer.votes_sum).to eq -1
      end

      context 'double vote' do
        before { subject }
        it 'should not change Votes count' do
          expect { subject }.to_not change(another_answer.votes, :count)
        end
      end
    end

    context 'question author can not vote for Answer' do
      subject { post :vote_minus, question_id: question, id: answer }
      it 'should not change Votes count' do
        expect { subject }.to_not change(Vote, :count)
      end

      it 'should have votes sum' do
        subject
        expect(another_answer.votes_sum).to eq 0
      end
    end
  end

  describe 'POST #re_vote' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    let!(:vote) { create(:vote, user: user, voteable: answer, value: 1) }

    before { sign_in user }

    context 're-vote' do
      subject { post :re_vote, question_id: question, id: answer }

      it 'should destroy vote to user' do
        expect { subject }.to change(Vote, :count).by(-1)
      end
    end
  end
end
