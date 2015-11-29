require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { should belong_to :user }
end
