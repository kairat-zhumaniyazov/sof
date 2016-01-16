require_relative '../acceptance_helper'

feature 'For best answer author', %q{
  In order to best answer
  For signed user
  i want change reputation for best answer author
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  given(:another_answer_author) { create(:user) }
  given!(:another_answer) { create(:answer, question: question, user: another_answer_author) }

  given(:best_answer_author) { create(:user) }
  given!(:best_answer) { create(:answer, question: question, user: best_answer_author) }

  before do
    sign_in user
    visit question_path question
  end

  scenario 'Choose best answer by question author', js: true do
    within "##{dom_id(best_answer)}" do
      click_on 'Best answer'
    end
    click_on 'Sign out'
    sign_in another_answer_author
    expect(page).to have_content 'Your reputation is: 2'

    click_on 'Sign out'
    sign_in best_answer_author
    expect(page).to have_content 'Your reputation is: 4'
  end
end
