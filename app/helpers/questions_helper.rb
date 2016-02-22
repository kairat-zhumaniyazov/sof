module QuestionsHelper
  def hashtags_to_links(text)
    text
      .gsub(Question::HASHTAG_REGEXP_PATTERN) { hashtag_link(Regexp.last_match(1)) }
      .html_safe
  end

  def hashtag_link(hashtag)
    link_to("##{hashtag}", tagged_questions_path(hashtag.downcase))
  end
end
