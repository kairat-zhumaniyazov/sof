require_relative '../acceptance_helper'

feature 'Vote for question', %q{
  In order to vote for question
  For signed user
  i want change reputation for question author
} do

  given(:user) { create(:user) }
  given(:question_author) { create(:user) }
  given(:question) { create(:question, user: question_author) }

  before do
    sign_in user
    visit question_path question
  end

  scenario 'Vote PLUS', js: true do
    within '.question' do
      click_on '+'
    end

    within '.sign-info' do
      click_on 'Sign out'
    end
    sign_in question_author

    expect(page).to have_content 'Your reputation is: 2'
  end

  scenario 'Vote MINUS', js: true do
    within '.question' do
      click_on '-'
    end

    within '.sign-info' do
      click_on 'Sign out'
    end
    sign_in question_author

    expect(page).to have_content 'Your reputation is: -2'
  end
end
