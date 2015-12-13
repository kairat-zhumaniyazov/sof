require 'rails_helper'

describe Api::V1::QuestionsController, type: :controller do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'should returns 401 status if there is no access_token' do
        get :index, format: :json
        expect(response.status).to eq 401
      end

      it 'should returns 401 status if access_token is invalid' do
        get :index, format: :json, access_token: '123456'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user, admin: true) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get :index, format: :json, access_token: access_token.token }

      it 'should returns status 200' do
        expect(response).to be_success
      end

      it 'should return list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "questions object should contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'question object should contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('questions/0/short_title')
      end

      context 'answers' do
        it 'should included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "answer object should contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET #show' do
    let(:me) { create(:user, admin: true) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:comment) { create(:comment, commentable: question, user: me) }
    let!(:attachment) { create(:attachment, attachable: question) }

    context 'unauthorized' do
      it 'should returns 401 status if there is no access_token' do
        get :show, id: question.id, format: :json
        expect(response.status).to eq 401
      end

      it 'should returns 401 status if access_token is invalid' do
        get :show, id: question.id, format: :json, access_token: '123456'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      before { get :show, id: question, format: :json, access_token: access_token.token }

      it 'should returns status 200' do
        expect(response).to be_success
      end

      it 'should return question object' do
        expect(response.body).to be_json_eql(question.to_json).at_path('question').excluding('answers', 'attachments', 'comments')
      end

      context 'question have answers' do
        %w(id body created_at updated_at question_id).each do |attr|
          it "question answer should have #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("question/answers/0/#{attr}")
          end
        end
      end

      context 'question have commnets' do
        %w(id body user_id commentable_id commentable_type created_at updated_at).each do |attr|
          it "question comment should have #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'question have attachments' do
        %w(id file).each do |attr|
          it "question attachment should have #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("question/attachments/0/#{attr}")
          end
        end

        it 'question attachment should have url for attachment' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('question/attachments/0/file/file/url')
        end
      end
    end
  end
end
