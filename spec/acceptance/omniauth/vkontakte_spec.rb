require_relative '../acceptance_helper'

feature 'Authorization by Vkontakte', %q{
  In order to authorize by vkontakte with omniauth
  As an facebook user
  I want to be authorize by vkontakte
} do

  before { visit new_user_session_path }

  scenario 'User can authorize by Vkontakte' do
    mock_auth_hash(:vkontakte)
    click_on 'Sign in with Vkontakte'

    expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
  end

  scenario 'Fail authorization with Vkontakte' do
    OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
    click_on 'Sign in with Vkontakte'

    expect(page).to have_content 'Could not authenticate you from Vkontakte because "Invalid credentials"'
  end

end
