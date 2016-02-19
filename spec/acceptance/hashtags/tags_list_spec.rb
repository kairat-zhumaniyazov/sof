require_relative '../acceptance_helper'

feature 'Tags list for each question', %q{
  In order to questions list
  As an user
  I want to be able to see tags list for each question
} do

  given!(:question_1) { create(:question, body: 'With #tag_1 and #tag_2') }
  given!(:question_2) { create(:question, body: 'With #tag_3, #tag_4 and #tag_5') }

  scenario 'questions index' do
    visit questions_path

    within "##{dom_id question_1}" do
      within '.tags-list' do
        expect(page).to have_link 'tag_1'
        expect(page).to have_link 'tag_2'
      end
    end

    within "##{dom_id question_2}" do
      within '.tags-list' do
        expect(page).to have_link 'tag_3'
        expect(page).to have_link 'tag_4'
        expect(page).to have_link 'tag_5'
      end
    end
  end

end
