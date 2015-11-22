require 'rails_helper'

shared_examples_for 'voteable' do
  let(:model) { described_class }

  it 'has a vote_sum' do
    voted_to = create(model.to_s.underscore.to_sym)
    expect(voted_to.votes_sum).to eq 0
  end
end
