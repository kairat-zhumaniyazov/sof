require_relative '../acceptance_helper'
require_relative '../sphinx_helper'

feature 'Search Comment', %q{
  In order to get comment with Sphinx
  As an user
  I want to be able to Search with Sphinx
} do

  describe 'Searching in Comments' do
    describe 'for Questions comment' do
      given!(:q_with_matched_comment) { create(:question) }
      given!(:comment_with_matched_body) { create(:comment, body: 'Find me comment body', commentable: q_with_matched_comment) }
      given!(:q_without_matched_comment) { create(:question) }
      given!(:comment_without_matched_body) { create(:comment, body: 'blah-blah-blah', commentable: q_without_matched_comment) }

      scenario 'search comment', js: true do
        build_index
        visit root_path
        fill_in 'search_query_q', with: 'Find me'
        select 'comments', from: 'search_query_index'
        click_on 'Search'

        expect(current_path).to eq search_path

        expect(page).to have_link q_with_matched_comment.title, href: question_path(q_with_matched_comment)
        expect(page).to_not have_content q_without_matched_comment
      end
    end

    describe 'for Answers comment' do
      given!(:a_with_matched_comment) { create(:answer) }
      given!(:comment_with_matched_body) { create(:comment, body: 'Find me comment body', commentable: a_with_matched_comment) }
      given!(:a_without_matched_comment) { create(:answer) }
      given!(:comment_without_matched_body) { create(:comment, body: 'blah-blah-blah', commentable: a_without_matched_comment) }

      scenario 'search comment', js: true do
        build_index
        visit root_path
        fill_in 'search_query_q', with: 'Find me'
        select 'comments', from: 'search_query_index'
        click_on 'Search'

        expect(current_path).to eq search_path

        expect(page).to have_link a_with_matched_comment.question.title, href: question_path(a_with_matched_comment.question)
        expect(page).to_not have_content a_without_matched_comment.question
      end
    end
  end

end
