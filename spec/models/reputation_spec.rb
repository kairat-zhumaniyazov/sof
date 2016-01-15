require 'rails_helper'

RSpec.describe Reputation, type: :model do
  it { should belong_to :user }

  describe '#sum' do
    let(:user) { create(:user) }
    let!(:reputation_1) { create(:reputation, user: user, value: 1) }
    let!(:reputation_2) { create(:reputation, user: user, value: 3) }

    subject { user.reputations.sum(:value) }

    it 'should return reputations sum' do
      expect(subject).to eq 4
    end
  end

  describe '.add' do
    let(:user) { create(:user) }
    subject { user.reputations.add(Reputation::FOR_NEW_ANSWER_TO_ANOTHER_QUESTION) }

    it 'should change reputations count' do
      expect { subject }.to change(user.reputations, :count).by(1)
    end

    it 'should have right reputations sum' do
      subject
      expect(user.reputations.sum(:value)).to eq 1
    end
  end
end
