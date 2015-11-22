require_relative '../acceptance_helper'

feature 'Vote for the question', %q{
  In order to vote the question
  For authorized user
  i want vote for the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:another_answer) { create(:answer, question: question) }

  describe 'Authorized user' do
    before do
      sign_in user
      visit question_path question
    end

    describe 'can vote' do

      scenario 'PLUS', js: true do

        within "##{dom_id(another_answer)}" do
          within '.votes' do
            click_on '+'
            expect(page).to have_content '1'
          end
        end
      end

      scenario 'MINUS', js: true do

        within "##{dom_id(another_answer)}" do
          within '.votes' do
            click_on '-'
            expect(page).to have_content '-1'
          end
        end
      end
    end

    describe 'only once' do
      scenario 'PLUS 2 times', js: true do

        within "##{dom_id(another_answer)}" do
          within '.votes' do
            click_on '+'
            click_on '+'
            expect(page).to have_content '1'
          end
        end
      end

      scenario 'MINUS 2 times', js: true do

        within "##{dom_id(another_answer)}" do
          within '.votes' do
            click_on '-'
            click_on '-'
            expect(page).to have_content '-1'
          end
        end
      end
    end

    describe 'can not vote' do
      scenario 'user is answers author' do
        visit question_path question
        within "##{dom_id(answer)}" do
          expect(page).to_not have_link '+'
          expect(page).to_not have_link '-'
          expect(page).to have_content '0'
        end
      end
    end
  end

  describe 'Non-authorized user can not vote' do
    scenario 'user dont have votes link' do
      visit question_path question
      within "##{dom_id(another_answer)}" do
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
        expect(page).to have_content '0'
      end
    end
  end

end
