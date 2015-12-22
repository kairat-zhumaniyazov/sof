require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    before { sign_in user }

    context 'Comments for Question' do
      subject { post :create, question_id: question, comment: attributes_for(:comment, commentable: 'Question'), format: :js }

      it 'should be right question' do
        subject
        expect(assigns(:commentable)).to eq question
      end

      it 'should change questions comment count' do
        expect { subject }.to change(question.comments, :count).by(1)
      end
    end

    context 'Comments for Answer' do
      subject { post :create, question_id: question, answer_id: answer, comment: attributes_for(:comment, commentable: 'Answer'), format: :js }

      it 'should be right Answer' do
        subject
        expect(assigns(:commentable)).to eq answer
      end

      it 'should change answers comments count' do
        expect { subject }.to change(answer.comments, :count).by(1)
      end
    end

    context 'Invalid comment' do
      it 'should not create comment for question' do
        expect {
          post :create, question_id: question, comment: attributes_for(:invalid_comment, commentable: 'Question'), format: :js
        }.to_not change(Comment, :count)
      end

      it 'should not create comment for answer' do
        expect {
          post :create, question_id: question, answer_id: answer, comment: attributes_for(:invalid_comment, commentable: 'Answer'), format: :js
        }.to_not change(Comment, :count)
      end
    end
  end
end
