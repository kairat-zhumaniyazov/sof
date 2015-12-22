require 'rails_helper'
require 'active_attr/rspec'

RSpec.describe SearchQuery, type: :model do
  it { should have_attribute :q }
  it { should have_attribute :index }

  it { should validate_inclusion_of(:index).in_array([nil, *SearchQuery::INDICES]) }
end
