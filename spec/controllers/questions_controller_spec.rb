require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET :index' do
    let(:questions) { create_list(:question, 2) }
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
    before { get :new }
    it 'should have new question' do
      expect(assigns(:question)).to be_a_new Question
    end
    it 'should render :new template' do
      expect(response).to render_template :new
    end
  end
end
