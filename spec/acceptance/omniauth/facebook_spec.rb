require_relative '../acceptance_helper'

feature 'Authorization by Facebook', %q{
  In order to authorize by Facebook with omniauth
  As an facebook user
  I want to be authorize by Facebook
} do

  before { visit new_user_session_path }

  scenario 'User can authorize by Facebook' do
    mock_auth_hash(:facebook)
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account.'
  end

  scenario 'Fail authorization with Facebook' do
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Could not authenticate you from Facebook because "Invalid credentials"'
  end

end
