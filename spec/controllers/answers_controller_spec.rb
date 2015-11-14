require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe "GET :new" do
    before { get :new, question_id: question }
    it 'should be right question' do
      expect(assigns(:question)).to eq question
    end
    it 'should have new answer' do
      expect(assigns(:answer)).to be_a_new Answer
    end
    it 'should render :new template' do
      expect(response).to render_template :new
    end
  end

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
        expect { delete :destroy, question_id: answer.question, id: answer }.to change(Answer, :count).by(-1)
      end
      it 'should redirect to question show page' do
        sign_in user
        delete :destroy, question_id: question, id: answer
        expect(response).to redirect_to question_path question
      end
    end

    context 'non-signed in user' do
      it 'should not delete answer' do
        expect { delete :destroy, question_id: answer.question, id: answer }.to_not change(Answer, :count)
      end
    end
  end
end
