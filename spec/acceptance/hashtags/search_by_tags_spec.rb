require_relative '../acceptance_helper'
require_relative '../sphinx_helper'

feature 'Search By Tags', %q{
  In order to get question by tag
  As an user
  I want to be able to Search by tags
} do

  given!(:question_1) { create(:question, body: 'Q1 with #ruby') }
  given!(:question_2) { create(:question, body: 'Q2 with #rails') }
  given!(:question_3) { create(:question, body: 'Q3 with #ruby, #rails and #rubyonrails') }


  before do
    visit root_path
    select 'tags', from: 'search_query_index'
  end

  describe 'with 1 match' do
    scenario 'hashtag #rubyonrails' do
      fill_in 'search_query_q', with: 'rubyonrails'
      select 'tags', from: 'search_query_index'
      click_on 'Search'

      expect(page).to_not have_link question_1.title
      expect(page).to_not have_link question_2.title
      expect(page).to have_link question_3.title
    end

    scenario 'hashtag #ruby' do
      fill_in 'search_query_q', with: 'ruby'
      click_on 'Search'

      expect(page).to have_link question_1.title
      expect(page).to_not have_link question_2.title
      expect(page).to have_link question_3.title
    end

    scenario 'hashtag #rails' do
      fill_in 'search_query_q', with: 'rails'
      click_on 'Search'

      expect(page).to_not have_link question_1.title
      expect(page).to have_link question_2.title
      expect(page).to have_link question_3.title
    end
  end

  describe 'with 2 match' do
    scenario 'hashtags #rails and #ruby' do
      fill_in 'search_query_q', with: 'rails ruby'
      click_on 'Search'

      expect(page).to_not have_link question_1.title
      expect(page).to_not have_link question_2.title
      expect(page).to have_link question_3.title
    end
  end
end
