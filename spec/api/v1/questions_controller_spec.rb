require 'rails_helper'

describe Api::V1::QuestionsController do
  let(:me) { create(:user, admin: true) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.last }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it_behaves_like 'API :get request successfully responsible'

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

    def do_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end
  end

  describe 'GET #show' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:comment) { create(:comment, commentable: question, user: me) }
    let!(:attachment) { create(:attachment, attachable: question) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it_behaves_like 'API :get request successfully responsible'

      it 'should return question object' do
        p response.body
        expect(response.body).to be_json_eql(question.to_json).at_path('question').
          excluding('answers', 'attachments', 'comments')
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
        it 'question attachment should have url for attachment' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('question/attachments/0/file')
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST #create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      context 'with valid params' do
        it 'should be success status' do
          post '/api/v1/questions', question: attributes_for(:question), format: :json, access_token: access_token.token
          expect(response).to have_http_status(:created)
        end

        it 'should create new question for user' do
          expect {
            post '/api/v1/questions', question: attributes_for(:question), format: :json, access_token: access_token.token
          }.to change(me.questions, :count).by(1)
        end
      end

      context 'with invalid params' do
        it 'should have status 422' do
          post '/api/v1/questions', question: attributes_for(:invalid_question), format: :json, access_token: access_token.token
          expect(response.status).to eq 422
        end
        it 'should create new question for user' do
          expect {
            post '/api/v1/questions', question: attributes_for(:invalid_question), format: :json, access_token: access_token.token
          }.to_not change(Question, :count)
        end
      end
    end

    def do_request(options = {})
      post '/api/v1/questions', { format: :json }.merge(options)
    end
  end
end
