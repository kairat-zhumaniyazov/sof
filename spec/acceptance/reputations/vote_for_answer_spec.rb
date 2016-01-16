require_relative '../acceptance_helper'

feature 'Vote for answer', %q{
  In order to vote for answer
  For signed user
  i want change reputation for answer author
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer_author) { create(:user) }
  given!(:answer) { create(:answer, user: answer_author, question: question) }

  before do
    sign_in user
    visit question_path question
  end

  scenario 'Vote PLUS', js: true do
    within "##{dom_id(answer)}" do
      click_on '+'
    end

    within '.sign-info' do
      click_on 'Sign out'
    end
    sign_in answer_author

    expect(page).to have_content 'Your reputation is: 3'
  end

  scenario 'Vote MINUS', js: true do
    within "##{dom_id(answer)}" do
      click_on '-'
    end

    within '.sign-info' do
      click_on 'Sign out'
    end
    sign_in answer_author

    expect(page).to have_content 'Your reputation is: 1'
  end
end
