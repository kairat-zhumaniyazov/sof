require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let!(:user) { create(:user, email: 'mock_user@test.com') }

  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe '#facebook' do
    before do
      request.env['omniauth.auth'] = mock_auth_hash :facebook
      get :facebook
    end

    context 'User exists' do
      it 'should not create User' do
        expect { get :facebook }.to_not change(User, :count)
      end

      it 'should be right User' do
        expect(assigns(:user)).to eq user
      end

      it 'should create session' do
        expect(subject.current_user).to eq user
      end

      it 'should redirect to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'User does not exists' do
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new(provider: 'facebook', uid: '222222', info: { email: 'another@user.com' })
      end

      it 'should create new User' do
        expect { get :facebook }.to change(User, :count).by(1)
      end

      it 'should be right User' do
        get :facebook
        expect(assigns(:user).email).to eq 'another@user.com'
      end

      it 'should create session' do
        get :facebook
        expect(subject.current_user.email).to eq 'another@user.com'
      end

      it 'should redirect to root_path' do
        get :facebook
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#vkontakte' do
    before do
      request.env['omniauth.auth'] = mock_auth_hash :vkontakte
      get :vkontakte
    end

    context 'User exists' do
      it 'should not create User' do
        expect { get :vkontakte }.to_not change(User, :count)
      end

      it 'should be right User' do
        expect(assigns(:user)).to eq user
      end

      it 'should create session' do
        expect(subject.current_user).to eq user
      end

      it 'should redirect to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'User does not exists' do
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '222222', info: { email: 'another@user.com' })
      end

      it 'should create new User' do
        expect { get :vkontakte }.to change(User, :count).by(1)
      end

      it 'should be right User' do
        get :vkontakte
        expect(assigns(:user).email).to eq 'another@user.com'
      end

      it 'should create session' do
        get :vkontakte
        expect(subject.current_user.email).to eq 'another@user.com'
      end

      it 'should redirect to root_path' do
        get :vkontakte
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#twitter' do
    before do
      request.env['omniauth.auth'] = mock_auth_hash :twitter
    end

    context 'user not have auth and not registered' do
      it 'should redirect' do
        get :twitter
        expect(response).to redirect_to email_required_path
      end

      it 'should not to change User count' do
        expect {
          get :twitter
        }.to_not change(User, :count)
      end
    end

    context 'User have auth and registered' do
      it 'should return a right User' do
        user.authorizations.create(provider: request.env['omniauth.auth'].provider, uid: request.env['omniauth.auth'].uid)
        get :twitter
        expect(assigns(:user)).to eq user
      end

      it 'should not to change User count' do
        expect {
          get :twitter
        }.to_not change(User, :count)
      end
    end
  end
end
