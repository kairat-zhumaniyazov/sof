require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET :index' do
    let(:questions) { FactoryGirl.create_list(:question, 2) }
    before { get :index }

    it 'should have questions array' do
      expect(assigns(:questions)).to eq questions
    end
    it 'should render :index template' do
      expect(response).to render_template :index
    end
  end
end
