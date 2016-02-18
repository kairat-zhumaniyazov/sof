require_relative '../acceptance_helper'

feature 'Edit question with hashtag', %q{
  In order to created/update question
  As an authenticated user
  I want to be able to add/delete hashtag
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user, body: 'This is #hashtag1, #hashtag2') }

  describe 'edit question' do
    before do
      sign_in user
      visit question_path question
    end

    scenario 'add new hashtag' do
      within "##{dom_id question}" do
        click_on 'Edit'
        within '#edit-question-form-container' do
          fill_in 'Body', with: 'This is #hashtag1, #hashtag2, #hashtag3'
          click_on 'Save'
        end

        click_on 'Save'
      end

      expect(page).to have_link '#hashtag1'
      expect(page).to have_link '#hashtag2'
      expect(page).to have_link '#hashtag3'
    end

    scenario 'delete one hashtag' do
      within "##{dom_id question}" do
        click_on 'Edit'
        within '#edit-question-form-container' do
          fill_in 'Body', with: 'This is #hashtag2, #hashtag3'
          click_on 'Save'
        end
      end

      expect(page).to_not have_link '#hashtag1'
      expect(page).to have_link '#hashtag2'
      expect(page).to have_link '#hashtag3'
    end
  end
end
