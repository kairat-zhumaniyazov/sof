require_relative '../acceptance_helper'

feature 'User sign up', %q{
  In order to be able to have full functionality
  As an User
  I want to be able to Sign up
} do

  given(:user_params) { attributes_for(:user) }

  describe 'Registration with valid attributes' do
    scenario 'without avatar' do
      visit new_user_registration_path
      fill_in 'Email', with: user_params[:email]
      fill_in 'Nickname', with: user_params[:nickname]
      fill_in 'Password', with: user_params[:password]
      fill_in 'Password confirmation', with: user_params[:password]
      click_button 'Sign up'
      expect(page).to have_content 'A message with a confirmation link has been sent to your email address.'
      expect(current_path).to eq root_path
    end

    scenario 'with valid avatar' do
      visit new_user_registration_path
      fill_in 'Email', with: user_params[:email]
      fill_in 'Nickname', with: user_params[:nickname]
      fill_in 'Password', with: user_params[:password]
      fill_in 'Password confirmation', with: user_params[:password]
      attach_file('Avatar', "#{Rails.root}/spec/fixtures/avatar.jpg")
      click_button 'Sign up'
      expect(page).to have_content 'A message with a confirmation link has been sent to your email address.'
      expect(current_path).to eq root_path
    end
  end



  scenario 'Registration with invalid attributes' do
    visit new_user_registration_path
    fill_in 'Email', with: 'not_a_email'
    fill_in 'Password', with: '123123123'
    fill_in 'Password confirmation', with: ''
    click_button 'Sign up'

    expect(page).to have_content '4 errors prohibited this user from being saved'
    expect(current_path).to eq user_registration_path
  end

  scenario 'with invalid avatar file' do
    visit new_user_registration_path
    fill_in 'Email', with: user_params[:email]
    fill_in 'Nickname', with: user_params[:nickname]
    fill_in 'Password', with: user_params[:password]
    fill_in 'Password confirmation', with: user_params[:password]
    attach_file('Avatar', "#{Rails.root}/spec/rails_helper.rb")
    click_button 'Sign up'
    expect(page).to have_content '1 error prohibited this user from being saved'
    expect(current_path).to eq user_registration_path
  end

end
