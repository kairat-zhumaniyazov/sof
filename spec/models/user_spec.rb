require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should validate_presence_of :nickname }

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribes).through(:subscriptions).source(:question) }

  it { should accept_nested_attributes_for :authorizations }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123123123') }

    context 'for facebook' do
      context 'User allready has authorization' do
        it 'should return the right user' do
          user.authorizations.create(provider: 'facebook', uid: '123123123')
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'User has not authorization' do
        context 'user already exists' do
          let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123123123', info: { email: user.email })}
          it 'should not create new user' do
            expect { User.find_for_oauth(auth) }.to_not change(User, :count)
          end

          it 'should create new authorization for user' do
            expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
          end

          it 'should create right authorization' do
            authorization = User.find_for_oauth(auth).authorizations.first

            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end

          it 'should return user' do
            expect(User.find_for_oauth(auth)).to eq user
          end
        end

        context 'user does not exist' do
          let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123123123', info: { email: 'newuser@test.com' })}

          it 'should create new user' do
            expect{ User.find_for_oauth(auth) }.to change(User, :count).by(1)
          end

          it 'should return user' do
            expect(User.find_for_oauth(auth)).to be_a User
          end

          it 'should fills user email' do
            user = User.find_for_oauth(auth)
            expect(user.email).to eq auth.info.email
          end

          it 'should create authorization for user' do
            user = User.find_for_oauth(auth)
            expect(user.authorizations).to_not be_empty
          end

          it 'should create right authorization' do
            authorization = User.find_for_oauth(auth).authorizations.first
            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end
        end
      end

      context 'twitter' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123123123', info: { email: nil })}
        context 'user dont not exist' do
          it 'should return nil' do
            expect(User.find_for_oauth(auth)).to be nil
          end
        end

        context 'user exist' do
          let(:user) { create(:user) }
          let!(:authorization) { user.authorizations.create(provider: auth.provider, uid: auth.uid) }
          it 'should return user object' do
            expect(User.find_for_oauth(auth)).to eq user
          end
        end
      end
    end
  end

  describe '.create_with_psw' do
    it 'should create new user with random psw' do
      expect(User.create_with_psw('test@test.com', 'test_nickname')).to be_a User
    end

    it 'should not create new user with random psw' do
      expect(User.create_with_psw('test@test.com', '')).to be nil
    end
  end
end
