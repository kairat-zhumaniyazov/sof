require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe "POST :create" do
    sign_in_user

    it 'should be right question' do
      post :create, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:question)).to eq question
    end

    context "with valid params" do
      it 'should create new answer' do
        expect {
          post :create, question_id: question, answer: attributes_for(:answer), format: :js
        }.to change(question.answers, :count).by(1)
      end
      it 'should render :create template' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
      it 'should have right answer owner' do
        expect {
          post :create, question_id: question, answer: attributes_for(:answer), format: :js
        }.to change(@user.answers, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'should not create new answer' do
        expect {
          post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        }.to_not change(Answer, :count)
      end
      it 'should render :create template' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, user: user, question: question) }
    context 'signed in user' do
      it 'should delete answer' do
        sign_in user
        expect {
          delete :destroy, question_id: answer.question, id: answer, format: :js
        }.to change(Answer, :count).by(-1)
      end
      it 'should redirect to question show page' do
        sign_in user
        delete :destroy, question_id: question, id: answer, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'non-signed in user' do
      it 'should not delete answer' do
        expect {
          delete :destroy, question_id: answer.question, id: answer, format: :js
        }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    let(:answer) { create(:answer, user: user, question: question) }
    it 'should be right question' do
      patch :update, question_id: question, id: answer, answer: { body: 'updated body' }, format: :js
      expect(assigns(:question)).to eq question
    end
    it 'should be right answer' do
      patch :update, question_id: question, id: answer, answer: { body: 'updated body' }, format: :js
      expect(assigns(:answer)).to eq answer
    end
    it 'should change answer' do
      patch :update, question_id: question, id: answer, answer: { body: 'updated body' }, format: :js
      answer.reload
      expect(answer.body).to eq 'updated body'
    end
    it 'should render update template' do
      patch :update, question_id: question, id: answer, answer: { body: 'updated body' }, format: :js
      expect(response).to render_template :update
    end

  end
end
