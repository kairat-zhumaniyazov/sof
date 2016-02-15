require_relative '../acceptance_helper'

feature 'New answer for question', %q{
  In order to create new answer
  For Answer Author
  i want change reputation to user
} do

  given(:user) { create(:user) }

  before do
    sign_in user
    visit question_path question
    click_on 'New answer'
  end

  describe 'First answer for question' do
    describe 'for not question author' do
      given(:question) { create(:question) }

      scenario 'create answer', js: true do
        expect(page).to have_content 'Your reputation is: 0'

        within '#new-answer-form' do
          fill_in 'Answer body', with: 'My Answer'
          click_on 'Create Answer'
        end

        visit question_path question

        expect(page).to have_content 'Your reputation is: 2'
      end
    end

    describe 'for question author' do
      given(:question) { create(:question, user: user) }

      scenario 'create answer', js: true do
        expect(page).to have_content 'Your reputation is: 0'

        within '#new-answer-form' do
          fill_in 'Answer body', with: 'My Answer'
          click_on 'Create Answer'
        end

        visit question_path question

        expect(page).to have_content 'Your reputation is: 4'
      end
    end
  end

  describe 'Not first answer' do
    describe 'for not question author' do
      given(:question) { create(:question) }
      given!(:first_answer) { create(:answer, question: question) }

      scenario 'create answer', js: true do
        expect(page).to have_content 'Your reputation is: 0'

        within '#new-answer-form' do
          fill_in 'Answer body', with: 'My Answer'
          click_on 'Create Answer'
        end

        visit question_path question

        expect(page).to have_content 'Your reputation is: 1'
      end
    end

    describe 'for question author' do
      given(:question) { create(:question, user: user) }
      given!(:first_answer) { create(:answer, question: question) }

      scenario 'create answer', js: true do
        expect(page).to have_content 'Your reputation is: 0'

        within '#new-answer-form' do
          fill_in 'Answer body', with: 'My Answer'
          click_on 'Create Answer'
        end

        visit question_path question

        expect(page).to have_content 'Your reputation is: 3'
      end
    end
  end
end
