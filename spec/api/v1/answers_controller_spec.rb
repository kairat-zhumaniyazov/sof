require 'rails_helper'

describe Api::V1::AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:me) { create(:user, admin: true) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET /index' do
    context 'unauthorized' do
      it 'should returns 401 status if there is no access_token' do
        get :index, question_id: question, id: question.id, format: :json
        expect(response.status).to eq 401
      end

      it 'should returns 401 status if access_token is invalid' do
          get :index, question_id: question, id: question.id, format: :json, access_token: '123456'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:answer) { answers.first }

      before { get :index, question_id: question, format: :json, access_token: access_token.token }

      it 'should returns status 200' do
        expect(response).to be_success
      end

      it 'should return list of questions' do
        expect(response.body).to have_json_size(3).at_path('answers')
      end

      %w(id body question_id created_at updated_at).each do |attr|
        it "answers object should contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET #show' do
    let!(:answer) { create(:answer, question: question) }
    let!(:comment) { create(:comment, commentable: answer, user: me) }
    let!(:attachment) { create(:attachment, attachable: answer) }

    context 'unauthorized' do
      it 'should returns 401 status if there is no access_token' do
        get :index, question_id: question, id: answer.id, format: :json
        expect(response.status).to eq 401
      end

      it 'should returns 401 status if access_token is invalid' do
          get :index, question_id: question, id: answer.id, format: :json, access_token: '123456'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      before { get :show, question_id: question, id: answer, format: :json, access_token: access_token.token }

      it 'should returns status 200' do
        expect(response).to be_success
      end

      %w(id body question_id created_at updated_at).each do |attr|
        it "answer should have #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'answer have commnets' do
        %w(id body user_id commentable_id commentable_type created_at updated_at).each do |attr|
          it "answer comment should have #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'answer have attachments' do
        it 'answer attachment should have url for attachment' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('answer/attachments/0/file')
        end
      end
    end
  end

  describe 'POST #create' do
    context 'unauthorized' do
      it 'should returns 401 status if there is no access_token' do
        post :create, question_id: question, format: :json
        expect(response.status).to eq 401
      end

      it 'should returns 401 status if access_token is invalid' do
        post :create, question_id: question, format: :json, access_token: '123456'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      context 'with valid params' do
        it 'should have success status' do
          post :create, question_id: question, answer: attributes_for(:answer), format: :json, access_token: access_token.token
          expect(response).to have_http_status(:created)
        end

        it 'should create new answer for question' do
          expect {
            post :create, question_id: question, answer: attributes_for(:answer), format: :json, access_token: access_token.token
          }.to change(question.answers, :count).by(1)
        end
      end

      context 'with invalid params' do
        it 'should have status 422' do
          post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token
          expect(response.status).to eq 422
        end
        it 'should create new question for user' do
          expect {
            post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token
          }.to_not change(Answer, :count)
        end
      end
    end
  end
end
