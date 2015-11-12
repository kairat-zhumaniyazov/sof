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
    
    context "with valid params" do
      it "should create new question" do
        expect {
          post :create, question: attributes_for(:question)
        }.to change(@user.questions, :count).by(1)
      end
      it 'should redirect to question show' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path assigns(:question)
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
end
