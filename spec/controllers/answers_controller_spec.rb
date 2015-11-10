require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

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
end
