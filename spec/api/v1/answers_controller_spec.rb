require 'rails_helper'

describe Api::V1::AnswersController do
  let(:question) { create(:question) }
  let(:me) { create(:user, admin: true) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", question_id: question, format: :json, access_token: access_token.token }

      it_behaves_like 'API :get request successfully responsible'

      it 'should return list of questions' do
        expect(response.body).to have_json_size(3).at_path('answers')
      end

      %w(id body question_id created_at updated_at).each do |attr|
        it "answers object should contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end

  describe 'GET #show' do
    let!(:answer) { create(:answer, question: question) }
    let!(:comment) { create(:comment, commentable: answer, user: me) }
    let!(:attachment) { create(:attachment, attachable: answer) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it_behaves_like 'API :get request successfully responsible'

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

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers/#{answer.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST #create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      context 'with valid params' do
        it 'should have success status' do
          post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: access_token.token
          expect(response).to have_http_status(:created)
        end

        it 'should create new answer for question' do
          expect {
            post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: access_token.token
          }.to change(question.answers, :count).by(1)
        end
      end

      context 'with invalid params' do
        it 'should have status 422' do
          post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token
          expect(response.status).to eq 422
        end
        it 'should create new question for user' do
          expect {
            post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token
          }.to_not change(Answer, :count)
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end
end
