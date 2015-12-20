require_relative '../acceptance_helper'

feature 'Subscribe to Question', %q{
  In order to be able to subscribe for new answers
  As an User
  I want to be able to subscribe
} do

  let(:question) { create(:question) }

  describe 'Signed in user' do
    let(:user) { create(:user) }

    scenario 'can subscribe and unsuscribe', js: true do
      sign_in user
      visit question_path question

      within '.question .subscribe-controls' do
        click_on 'Subscribe'
      end
      expect(page).to have_content 'You successfuly subscribed to question'

      within '.question .subscribe-controls' do
        expect(page).to_not have_link 'Subscribe'
      end

      visit question_path question

      click_on 'Unsubscribe'

      expect(page).to have_content 'You successfuly unsubscribed from question'
      within '.question .subscribe-controls' do
        expect(page).to_not have_link 'Unubscribe'
        expect(page).to have_link 'Subscribe'
      end
    end
  end

  scenario 'non-authorized user not have subscribe link' do
    visit question_path question
    within '.question' do
      expect(page).to_not have_link 'Subscribe'
      expect(page).to_not have_link 'Unsuscribe'
    end
  end

end
