require_relative '../acceptance_helper'
require_relative '../sphinx_helper'

feature 'Search User', %q{
  In order to get user with Sphinx
  As an user
  I want to be able to Search with Sphinx
} do

  given!(:user_with_match) { create(:user, email: 'find_me@test.com') }
  given!(:user_without_match) { create(:user, email: 'blah-blah-blah@test.com') }

  scenario 'Searching in Answers', js: true do
    build_index
    visit root_path
    fill_in 'search_query_q', with: 'find_me'
    select 'users', from: 'search_query_index'
    click_on 'Search'

    expect(current_path).to eq search_path
    expect(page).to have_content user_with_match.email
    expect(page).to_not have_content user_without_match.email
  end

end
