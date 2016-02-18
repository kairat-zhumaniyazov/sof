module Taggable
  extend ActiveSupport::Concern

  included do
    before_create :parse_tags
    before_save :parse_tags
  end

  private

  def parse_tags
    pattern = /(?:\s|^)(#(?!(?:\d+|\w+?_|_\w+?)(?:\s|$))([a-z0-9\-_]+))/i
    self.tags = body.scan(pattern).map(&:last)
  end
end
