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

  describe 'with click on hashtag' do
    describe 'from root page' do
      scenario '#rubyonrails' do
        visit root_path
        expect(page).to have_link question_1.title
        expect(page).to have_link question_2.title
        expect(page).to have_link question_3.title

        click_on 'rubyonrails'

        expect(current_path).to eq tagged_questions_path(tag: 'rubyonrails')
        expect(page).to_not have_link question_1.title
        expect(page).to_not have_link question_2.title
        expect(page).to have_link question_3.title
      end

      scenario '#rails' do
        visit root_path
        expect(page).to have_link question_1.title
        expect(page).to have_link question_2.title
        expect(page).to have_link question_3.title

        within "##{dom_id question_2}" do
          click_on 'rails'
        end

        expect(current_path).to eq tagged_questions_path(tag: 'rails')
        expect(page).to_not have_link question_1.title
        expect(page).to have_link question_2.title
        expect(page).to have_link question_3.title
      end
    end


    describe 'from question page' do
      scenario '#rubyonrails' do
        visit question_path question_3
        within '.tags-list' do
          click_on 'rubyonrails'
        end

        expect(current_path).to eq tagged_questions_path(tag: 'rubyonrails')
        expect(page).to_not have_link question_1.title
        expect(page).to_not have_link question_2.title
        expect(page).to have_link question_3.title
      end

      scenario '#rails' do
        visit question_path question_3
        within '.tags-list' do
          click_on 'rails'
        end

        expect(current_path).to eq tagged_questions_path(tag: 'rails')
        expect(page).to_not have_link question_1.title
        expect(page).to have_link question_2.title
        expect(page).to have_link question_3.title
      end
    end
  end

end
