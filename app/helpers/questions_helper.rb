module QuestionsHelper
  def hashtags_to_links(text)
    text
      .gsub(Question::HASHTAG_REGEXP_PATTERN, link_to('#\1', root_path))
      .html_safe
  end
end
