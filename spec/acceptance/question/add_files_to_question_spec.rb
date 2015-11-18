require_relative '../acceptance_helper'

feature 'Add files to question', %q{
  In order to create question with attached files
  As an authenticated user
  I want to be able to add files to question
} do

  given(:user) { create(:user) }

  background do
    sign_in user
    visit new_question_path
  end

  scenario 'User can attach files for question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'test text'
    attach_file('File', "#{Rails.root}/spec/rails_helper.rb")
    click_on 'Create'

    within '.question' do
      expect(page).to have_link 'rails_helper.rb', href: "/uploads/attachment/file/1/rails_helper.rb"
    end
  end

end