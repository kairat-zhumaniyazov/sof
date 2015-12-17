require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET :index' do
    let(:questions) { create_list(:question, 2, user: user) }
    before { get :index }

    it 'should have questions array' do
      expect(assigns(:questions)).to eq questions
    end
    it 'should render :index template' do
      expect(response).to render_template :index
    end
  end

  describe "GET :show" do
    before { get :show, id: question }
    it 'should have right question' do
      expect(assigns(:question)).to eq question
    end

    it 'should render :show template' do
      expect(response).to render_template :show
    end
  end

  describe "GET :new" do
    sign_in_user

    before { get :new }
    it 'should have new question' do
      expect(assigns(:question)).to be_a_new Question
    end

    it 'should render :new template' do
      expect(response).to render_template :new
    end
  end

  describe "POST :create" do
    sign_in_user
    subject { post :create, question: attributes_for(:question) }
    context "with valid params" do
      it 'should create new question for User' do
        expect { subject }.to change(@user.questions, :count).by(1)
      end
      it 'should redirect to question show' do
        subject
        expect(response).to redirect_to question_path assigns(:question)
      end

      it_behaves_like 'Publishable' do
        let(:channel) { '/questions' }
      end
    end

    context "with invalid params" do
      it 'should not create new question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end
      it 'should render :new' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:another_question) { create(:question, user: user) }

    context 'signed in question owner' do
      sign_in_user
      let!(:question) { create(:question, user: @user) }

      context 'question owner' do
        it 'should destroy question' do
          expect { delete :destroy, id: question }.to change(@user.questions, :count).by(-1)
        end
      end

      context 'Not question owner' do
        it 'should not destroy question' do
          expect{ delete :destroy, id: another_question }.to_not change(Question, :count)
        end
      end
    end

    context 'Non-signed in user' do
     it 'should not destroy question' do
       expect{ delete :destroy, id: another_question }.to_not change(Question, :count)
     end
    end
  end

  describe 'PATCH #update' do
    context 'Non-signed user' do
      it 'should not change question' do
        expect {
          patch :update, id: question, question: attributes_for(:question), format: :js
        }.to_not change{question}
      end
    end

    context 'Signed in user' do
      before { sign_in user }

      context 'with valid attrs' do
        it 'should be a right question' do
          patch :update, id: question, question: attributes_for(:question), format: :js
          expect(assigns(:question)).to eq question
        end
        it 'should change title' do
          patch :update, id: question, question: { title: 'Edited title', body: 'Edited body' }, format: :js
          question.reload
          expect(question.title).to eq 'Edited title'
        end
        it 'should change body' do
          patch :update, id: question, question: { title: 'Edited title', body: 'Edited body' }, format: :js
          question.reload
          expect(question.body).to eq 'Edited body'
        end
        it 'should render template :update' do
          patch :update, id: question, question: { title: 'Edited title', body: 'Edited body' }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid params' do
        it 'should not change title' do
          expect {
            patch :update, id: question, question: { title: '', body: 'Edited body' }, format: :js
          }.to_not change(question, :title)
        end
        it 'should not change body' do
          expect {
            patch :update, id: question, question: { title: 'Edited title', body: '' }, format: :js
          }.to_not change(question, :body)
        end
      end
    end
  end

  require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

  describe 'POST #vote_plus' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:another_question) { create(:question) }

    before { sign_in user }
    context 'not qusetion autor can vote for Question' do
      it 'should change Votes count' do
        expect {
          post :vote_plus, id: another_question
        }.to change(another_question.votes, :count).by(1)
      end

      it 'should have votes sum' do
        post :vote_plus, id: another_question
        expect(another_question.votes_sum).to eq 1
      end

      context 'double vote' do
        before { post :vote_plus, id: another_question }
        it 'should not change Votes count' do
          expect {
            post :vote_plus, id: another_question
          }.to_not change(another_question.votes, :count)
        end
      end

      context 're-vote' do
        let!(:vote) { create(:vote_for_question, user: user, voteable: another_question, value: -1) }
        it 'should not change Votes count' do
          expect {
            post :vote_plus, id: another_question
          }.to_not change(another_question.votes, :count)
        end

        it 'should change vote.value' do
          post :vote_plus, id: another_question
          vote.reload
          expect(vote.value).to eq 1
        end
      end
    end

    context 'question author can not vote for Question' do
      it 'should not change Votes count' do
        expect {
          post :vote_plus, id: question
        }.to_not change(Vote, :count)
      end

      it 'should have votes sum' do
        post :vote_plus, id: question
        expect(another_question.votes_sum).to eq 0
      end
    end
  end

  describe 'POST #vote_minus' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:another_question) { create(:question) }

    before { sign_in user }
    context 'not question autor can vote for Question' do
      it 'should change Votes count' do
        expect {
          post :vote_minus, id: another_question
        }.to change(another_question.votes, :count).by(1)
      end

      it 'should have votes sum' do
        post :vote_minus, id: another_question
        expect(another_question.votes_sum).to eq -1
      end

      context 'double vote' do
        before { post :vote_minus, id: another_question }
        it 'should not change Votes count' do
          expect {
            post :vote_minus, id: another_question
          }.to_not change(another_question.votes, :count)
        end
      end

      context 're-vote' do
        let!(:vote) { create(:vote_for_question, user: user, voteable: another_question, value: 1) }
        it 'should not change Votes count' do
          expect {
            post :vote_minus, id: another_question
          }.to_not change(another_question.votes, :count)
        end

        it 'should change vote.value' do
          post :vote_minus, id: another_question
          vote.reload
          expect(vote.value).to eq -1
        end
      end
    end

    context 'question author can not vote for Question' do
      it 'should not change Votes count' do
        expect {
          post :vote_minus, id: question
        }.to_not change(Vote, :count)
      end

      it 'should have votes sum' do
        post :vote_minus, id: question
        expect(another_question.votes_sum).to eq 0
      end
    end
  end

  describe 'POST #re_vote' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let!(:vote) { create(:vote, voteable: question, user: user, value: 1) }

    before { sign_in user }

    context 're-vote' do
      it 'should destroy vote for user' do
        expect {
          post :re_vote, id: question
        }.to change(Vote, :count).by(-1)
      end
    end
  end
end
