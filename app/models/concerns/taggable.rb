module Taggable
  extend ActiveSupport::Concern

  HASHTAG_REGEXP_PATTERN = /\B#(\w+)/i

  included do
    before_create :parse_tags
    before_save :parse_tags
  end

  private

  def parse_tags
    self.tags = body.scan(HASHTAG_REGEXP_PATTERN).map(&:last).map(&:downcase).uniq
  end
end
