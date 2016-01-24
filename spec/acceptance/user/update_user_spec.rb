require_relative '../acceptance_helper'

feature 'Update profile', %q{
  In order to be able to update profile
  As an User
  I want to be able to update user profile
} do

  given!(:user) { create(:user) }

  before do
    sign_in user
    visit user_path user
  end

  describe 'Update' do
    scenario 'own profile' do
      visit edit_user_registration_path

      fill_in 'Nickname', with: 'Updated_nickname'
      attach_file('Avatar', "#{Rails.root}/spec/fixtures/new_avatar.jpg")
      fill_in 'Current password', with: '12345678'
      click_on 'Update'

      visit user_path user
      expect(page).to have_content 'Updated_nickname'
      expect(page).to have_xpath("//img[@src=\"/uploads/user/avatar/#{user.id}/new_avatar.jpg\"]")
    end
  end
end
