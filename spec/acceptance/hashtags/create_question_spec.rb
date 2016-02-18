require_relative '../acceptance_helper'

feature 'Question with hashtag', %q{
  In order to created/update question
  As an authenticated user
  I want to be able to add/delete hashtag
} do

  given(:user) { create(:user) }

  describe 'create question' do
    before do
      sign_in user
      visit new_question_path
    end

    scenario 'with 2 valid hashtags' do
      fill_in 'Title', with: 'Question with hashtags'
      fill_in 'Body', with: 'This is question with #_hashtag1 and #2hashtag2'
      click_on 'Create'
      expect(page).to have_link '#_hashtag1'
      expect(page).to have_link '#2hashtag2'
    end

    scenario 'with not valid hashtags' do
      fill_in 'Title', with: 'Question with hashtags'
      fill_in 'Body', with: 'This is question with #_hash tag1 and #2has htag2 123#sdf'
      click_on 'Create'
      expect(page).to_not have_link '#_hash tag1'
      expect(page).to_not have_link '#2has htag2'
      expect(page).to_not have_link '123#asd'
    end
  end
end
