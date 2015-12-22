require_relative '../acceptance_helper'
require_relative '../sphinx_helper'

feature 'Search Answer', %q{
  In order to get answer with Sphinx
  As an user
  I want to be able to Search with Sphinx
} do

  given!(:q_with_matched_answer) { create(:question) }
  given!(:answer_with_matched_body) { create(:answer, body: 'Find me in answer body', question: q_with_matched_answer) }
  given!(:q_without_matched_answer) { create(:question) }
  given!(:nswer_without_matched_body) { create(:answer, body: 'blah-blah-blah', question: q_without_matched_answer)}

  scenario 'Searching in Answers', js: true do
    build_index
    visit root_path
    fill_in 'search_query_q', with: 'Find me'
    select 'answers', from: 'search_query_index'
    click_on 'Search'

    expect(current_path).to eq search_path
    expect(page).to have_link q_with_matched_answer.title, href: question_path(q_with_matched_answer)
    expect(page).to_not have_content q_without_matched_answer
  end

end
