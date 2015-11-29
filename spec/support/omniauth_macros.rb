module OmniauthMacros
  def mock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new ({
      provider: provider.to_s,
      uid: '123123123',
      info: {
        email: 'mock_user@test.com'
      }
    })
  end
end
