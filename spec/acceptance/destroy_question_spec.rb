require 'rails_helper'

feature 'Destroy Question', %q{
  In order to destroy  question
  For Question Owner
  I want to destroy question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:another_question) { create(:question) }

  scenario 'Signed in User(owner) can destroy question' do
    sign_in user
    visit question_path question

    click_on 'Delete question'
    expect(page).to have_content 'Your question deleted.'
  end

  scenario 'Non-sign in user can not destroy question' do
    visit question_path question
    click_on 'Delete question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Not owner can not destroy question' do
    sign_in user
    visit question_path another_question
    click_on 'Delete question'

    expect(page).to have_content 'You can not delete this question.'
  end
end