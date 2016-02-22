class SearchQuery
  include ActiveAttr::Model

  INDICES = %w(tag question answer comment user)

  attribute :q
  attribute :index

  validates :index, inclusion: { in: [nil, *INDICES] }
end
