require 'rails_helper'

RSpec.describe Reputation, type: :model do
  it { should belong_to :user }
end
