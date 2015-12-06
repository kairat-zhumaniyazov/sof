require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe '#email_required' do
    before { get :email_required }
    it 'should have new user object' do
      expect(assigns(:user)).to be_a_new User
    end
  end

  describe '#create_with_email' do
    context 'with valid email' do
      context 'when not registered' do
        let(:user_params) { attributes_for(:user, authorization: attributes_for(:auth_twitter)) }

        it 'should create new User' do
          expect {
            post :create_with_email, user: user_params
          }.to change(User, :count).by(1)
        end

        it 'should create new authorization' do
          expect {
            post :create_with_email, user: user_params
          }.to change(Authorization, :count).by(1)
        end

        it 'User authorization should not be nil' do
          post :create_with_email, user: user_params
          expect(assigns(:user).authorizations.first).to_not be nil
        end

        it 'should redirect to login path' do
          post :create_with_email, user: user_params
          expect(response).to redirect_to new_user_session_path
        end
      end

      context 'when already registered' do
        let!(:user) { create(:user) }
        let(:params) { user.attributes.merge(authorization: attributes_for(:auth_twitter)) }
        it 'should not create new user' do
          expect {
            post :create_with_email, user: params
          }.to_not change(User, :count)
        end

        it 'should create new user authorization' do
          expect {
            post :create_with_email, user: params
          }.to change(user.authorizations, :count).by(1)
        end
      end
    end

    context 'with invalid email' do
      let(:user_params) { { email: 'qwerty', authorizations_attributes: [provider: 'twitter', uid: '123123'] } }

      it 'should render email_required' do
        post :create_with_email, user: user_params
        expect(response).to render_template :email_required
      end
    end
  end

end
