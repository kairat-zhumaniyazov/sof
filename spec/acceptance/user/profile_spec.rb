require_relative '../acceptance_helper'

feature 'User profile', %q{
  In order to be able to show user profile
  As an User
  I want to be able to show user profile
} do

  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }

  given!(:user_questions) { create_list(:question, 6, user: user) }
  given!(:user_answers) { create_list(:answer, 6, user: user) }

  before do
    sign_in user
    visit user_path user
  end

  describe 'Profile link' do
    scenario 'for signied user' do
      visit root_path
      expect(page).to have_link 'Profile'
    end

    scenario 'for non-signed user' do
      click_on 'Sign out'
      expect(page).to_not have_link 'Profile'
    end
  end

  describe 'Edit profile link' do
    scenario 'for own profile' do
      expect(page).to have_link 'Edit profile'
    end

    scenario 'for another profile' do
      visit user_path other_user
      expect(page).to_not have_link 'Edit profile'
    end
  end

  scenario 'Last questions' do
    last_questions = user.questions.limit(5)
    within '.profile-questions' do
      last_questions.each do |question|
        expect(page).to have_link question.title
      end

      expect(page).to_not have_link user_questions.first.title
    end
  end

  scenario 'Last answers' do
    last_answers = user.answers.limit(5).order(created_at: :asc)
    within '.profile-answers' do
      last_answers.each do |answer|
        expect(page).to have_link answer.question.title
      end
    end
  end
end
