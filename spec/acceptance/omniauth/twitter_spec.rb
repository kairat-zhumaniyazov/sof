require_relative '../acceptance_helper'

feature 'Authorization by Twitter', %q{
  In order to authorize by Twitter with omniauth
  As an twitter user
  I want to be authorize by Twitter
} do

  before { visit new_user_session_path }

  describe 'User dont registered' do
    scenario 'User can authorize and register with new emaiil by Twitter' do
      mock_auth_hash(:twitter)
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'For registration you need to add your valid email.'
      fill_in 'Email', with: 'test@email.com'
      click_on 'Add'

      expect(page).to have_content 'Congratulations! Email successfully registered. You must verify your email address'
    end
  end

  describe 'User with registration' do
    let!(:user) { create(:user) }

    scenario 'User can authorize and bind with registered email' do
      mock_auth_hash(:twitter)
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'For registration you need to add your valid email.'
      fill_in 'Email', with: user.email
      click_on 'Add'

      expect(page).to have_content 'Email already registered in system. For binding you must verify your email address.'
    end
  end

  scenario 'Fail authorization with Twitter' do
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Could not authenticate you from Twitter because "Invalid credentials"'
  end

end
