require_relative '../acceptance_helper'
require_relative '../sphinx_helper'

feature 'Search Question', %q{
  In order to get question with Sphinx
  As an user
  I want to be able to Search with Sphinx
} do

  given!(:q_with_mathced_title) { create(:question, title: 'Find me question 1', body: 'blah-blah-blah') }
  given!(:q_with_mathced_body) { create(:question, title: 'Questions 2', body: 'Find me body') }
  given!(:q_without_matches) { create(:question, title: 'Question 3', body: 'blah-blah-blah') }


  scenario 'Searching in Questions', js: true do
    build_index
    visit root_path
    fill_in 'search_query_q', with: 'Find me'
    select 'questions', from: 'search_query_index'
    click_on 'Search'

    expect(current_path).to eq search_path
    expect(page).to have_link q_with_mathced_title.title, href: question_path(q_with_mathced_title)
    expect(page).to have_link q_with_mathced_body.title, href: question_path(q_with_mathced_body)
    expect(page).to_not have_link q_without_matches.title, href: question_path(q_without_matches)
  end

end
