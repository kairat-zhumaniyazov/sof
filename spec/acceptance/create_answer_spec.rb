require 'rails_helper'

feature 'Create Answer for Question', %q{
  In order to create Answer for Question
  For Signed in User
  i want to create answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Signed in user try to create answer' do
    sign_in user
    visit question_path question

    fill_in 'Answer body', with: 'My Answer'
    click_on 'Create Answer'

    within 'div.answers' do
      expect(page).to have_content 'My Answer'
    end
    expect(current_path).to eq question_path(question)
  end

  scenario 'non-signed in user try to create answer' do
    visit question_path question

    fill_in 'Answer body', with: 'My Answer'
    click_on 'Create Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end