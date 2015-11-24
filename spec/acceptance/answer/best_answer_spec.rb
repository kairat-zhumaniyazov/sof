require_relative '../acceptance_helper'

feature 'Choose best answer', %q{
  In order to choose best answer for question
  For Question Author
  i want choose answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  describe 'Question Author' do
    before do
      sign_in user
      visit question_path question
    end

    scenario 'have Best answer links' do
      within('.answers') do
        expect(page).to have_link('Best answer')
      end
    end

    scenario 'choose best answer', js: true do
      find(:link, "best-answer-link-#{answers.last.id}").click

      within("##{dom_id answers.first}") do
        expect(page).to_not have_selector('p#best-answer')
      end

      within("##{dom_id answers.last}") do
        expect(page).to have_selector('p#best-answer')
      end
    end

    scenario 'choose 2 times', js: true do
      all('a.best-answer-link')[0].click
      all('a.best-answer-link')[1].click
      within('.answers') do
        expect(page).to have_selector('p#best-answer', count: 1)
      end
    end
  end

  scenario 'Not a question Author dont have best answer links' do
    sign_in another_user
    visit question_path question
    within('.answers') do
      expect(page).to_not have_link('Best answer')
    end
  end

  scenario 'Non-authed user dont have best answer links' do
    visit question_path question
    within('.answers') do
      expect(page).to_not have_link('Best answer')
    end
  end
end
