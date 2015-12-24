require_relative '../acceptance_helper'
require_relative '../sphinx_helper'

feature 'Search in All indices', %q{
  In order to get ALL with Sphinx
  As an user
  I want to be able to Search with Sphinx
} do

  given!(:question_matched_title) { create(:question, title: 'Find_me title') }
  given!(:question_matched_body) { create(:question, body: 'Find_me body') }
  given!(:question_not_matched) { create(:question) }

  given!(:q_with_matched_answer) { create(:question) }
  given!(:answer_matched) { create(:answer, body: 'Find_me body', question: q_with_matched_answer) }
  given!(:q_without_matched_answer) { create(:question) }
  given!(:answer_not_matched) { create(:answer, question: q_without_matched_answer) }

  given!(:q_with_matched_comment) { create(:question) }
  given!(:comment_matched_for_q) { create(:comment, body: 'Find_me body', commentable: q_with_matched_comment)}
  given!(:q_without_matched_comment) { create(:question) }
  given!(:comment_not_matched_for_q) { create(:comment, commentable: q_without_matched_comment) }

  given!(:a_with_matched_comment) { create(:answer) }
  given!(:comment_matched_for_a) { create(:comment, body: 'Find_me body', commentable: a_with_matched_comment) }
  given!(:a_without_matched_comment) { create(:answer) }
  given!(:comment_not_matched_for_a) { create(:comment, commentable: a_without_matched_comment) }

  given!(:user_matched) { create(:user, email: 'find_me@test.com') }
  given!(:user_not_matched) { create(:user) }

  scenario 'Searching in Everywhere', js: true do
    build_index
    visit root_path
    fill_in 'search_query_q', with: 'Find_me'
    select 'Everywhere', from: 'search_query_index'
    click_on 'Search'

    expect(current_path).to eq search_path

    expect(page).to have_link question_matched_body.title
    expect(page).to have_link question_matched_title.title
    expect(page).to_not have_link question_not_matched.title

    expect(page).to have_link q_with_matched_answer.title
    expect(page).to_not have_link q_without_matched_answer.title

    expect(page).to have_link q_with_matched_comment.title
    expect(page).to_not have_link q_without_matched_comment.title

    expect(page).to have_link a_with_matched_comment.question.title
    expect(page).to_not have_link a_without_matched_comment.question.title

    expect(page).to have_content user_matched.email
    expect(page).to_not have_content user_not_matched.email
  end

end
