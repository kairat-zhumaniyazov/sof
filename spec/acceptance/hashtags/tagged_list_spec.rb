require_relative '../acceptance_helper'

feature 'Questions list by tag', %q{
  In order to search by tag
  As an user
  I want to be able to get list of questions by tag
} do

  given!(:question_1) { create(:question, body: 'Q1 with #ruby') }
  given!(:question_2) { create(:question, body: 'Q2 with #rails') }
  given!(:question_3) { create(:question, body: 'Q3 with #ruby, #rails and #rubyonrails') }

  describe 'with 1 match' do
    scenario '#rubyonrails' do
      visit '/questions/tagged/rubyonrails'
      expect(page).to_not have_link question_1.title
      expect(page).to_not have_link question_2.title
      expect(page).to have_link question_3.title
    end
  end

  describe 'with 2 match' do
    scenario '#ruby' do
      visit '/questions/tagged/ruby'
      expect(page).to have_link question_1.title
      expect(page).to_not have_link question_2.title
      expect(page).to have_link question_3.title
    end

    scenario '#rails' do
      visit '/questions/tagged/rails'
      expect(page).to_not have_link question_1.title
      expect(page).to have_link question_2.title
      expect(page).to have_link question_3.title
    end
  end

end
