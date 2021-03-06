require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    session["devise.oauth_data"] = OmniAuth::AuthHash.new(
      provider: 'twitter',
      uid: '222222',
      info: {
        image: 'http://abs.twimg.com/sticky/default_profile_images/default_profile_1_normal.png'
        } )
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
        subject { post :create_with_email, user: user_params }

        let(:user_params) { attributes_for(:user) }

        it 'should create new User' do
          expect { subject }.to change(User, :count).by(1)
        end

        it 'should create new authorization' do
          expect { subject }.to change(Authorization, :count).by(1)
        end

        it 'User authorization should not be nil' do
          subject
          expect(assigns(:user).authorizations.first).to_not be nil
        end

        it 'should redirect to login path' do
          subject
          expect(response).to redirect_to new_user_session_path
        end
      end

      context 'when already registered' do
        let!(:user) { create(:user) }
        let(:params) { user.attributes.merge(authorization: attributes_for(:auth_twitter)) }
        subject { post :create_with_email, user: { email: user.email } }

        it 'should not create new user' do
          expect { subject }.to_not change(User, :count)
        end

        it 'should create new user authorization' do
          expect { subject }.to change(user.authorizations, :count).by(1)
        end

        it 'should redirect to login path' do
          subject
          expect(response).to redirect_to new_user_session_path
        end
      end
    end

    context 'with invalid email' do
      let(:user_params) { { email: 'qwerty' } }

      it 'should render email_required' do
        post :create_with_email, user: user_params
        expect(response).to render_template :email_required
      end
    end
  end

end
