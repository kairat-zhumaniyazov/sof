require 'rails_helper'

describe Api::V1::ProfilesController, type: :controller do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'should returns 401 status if there is no access_token' do
        get :me, format: :json
        expect(response.status).to eq 401
      end

      it 'should returns 401 status if access_token is invalid' do
        get :me, format: :json, access_token: '123456'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get :me, format: :json, access_token: access_token.token }

      it 'should returns 200' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "should contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password crypted_password).each do |attr|
        it "should not contains #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

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
      let(:me) { create(:user) }
      let!(:user_list) { create_list(:user, 5) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get :index, format: :json, access_token: access_token.token }

      it 'should returns 200' do
        expect(response).to be_success
      end

      it 'should return other users list' do
        expect(response.body).to be_json_eql(user_list.to_json).at_path('profiles')
      end

      #it 'should not return authorized user in list' do
    end
  end
end