require 'rails_helper'

feature 'Destroy Anser', %q{
  In order to destroy answer
  For Answer Owner
  I want to destroy answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, user: user, question: question) }
  given(:another_answer) { create(:answer, user: create(:user), question: question) }

  scenario 'Signed in User can destroy answer' do
    answer
    sign_in user
    visit question_path question
    click_on 'Delete answer'
    expect(page).to have_content 'Your answer deleted.'
  end

  scenario 'non-sign in user can not destroy answer' do
    answer
    visit question_path question
    click_on 'Delete answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Not owner can not destroy answer' do
    another_answer
    sign_in user
    visit question_path question
    click_on 'Delete answer'
    expect(page).to have_content 'You can not delete this answer.'
  end
end
