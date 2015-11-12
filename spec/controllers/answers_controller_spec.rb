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
      post :create, question_id: question, answer: attributes_for(:answer)
      expect(assigns(:question)).to eq question
    end

    context "with valid params" do
      it 'should create new answer' do
        expect {
          post :create, question_id: question, answer: attributes_for(:answer)
        }.to change(question.answers, :count).by(1)
      end
      it 'should redirect to question' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path question
      end
    end

    context 'with invalid params' do
      it 'should not create new answer' do
        expect {
          post :create, question_id: question, answer: attributes_for(:invalid_answer)
        }.to_not change(Answer, :count)
      end
      it 'should render :new template' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end
    end
  end
end
