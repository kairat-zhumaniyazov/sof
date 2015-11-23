require_relative '../acceptance_helper'

feature 'Vote for the answer', %q{
  In order to vote the answer
  For authorized user
  i want vote for the answer
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
            expect(page).to have_content 'Re-vote?'
          end
        end
      end

      scenario 'MINUS', js: true do
        within "##{dom_id(another_answer)}" do
          within '.votes' do
            click_on '-'
            expect(page).to have_content '-1'
            expect(page).to have_content 'Re-vote?'
          end
        end
      end
    end

    describe 'only once' do
      describe 'when user voted before' do
        let!(:vote) { create(:vote, voteable: another_answer, user: user, value: 1) }

        before { visit question_path question }

        scenario 'see info about that' do
          within "##{dom_id(another_answer)}" do
            within '.votes' do
              expect(page).to have_content '1'
              expect(page).to have_content 'Re-vote?'
            end
          end
        end
      end

      describe 'can re-vote' do
        let!(:vote) { create(:vote, voteable: another_answer, user: user, value: 1) }
        before { visit question_path question }

        scenario 'when click re-vote link', js: true do
          within "##{dom_id(another_answer)} .votes" do
            expect(page).to have_link 'Re-vote?'
            click_on 'Re-vote'
            expect(page).to have_link '+'
            expect(page).to have_link '-'
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
