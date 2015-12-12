require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }

    let(:question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other) }
    let(:answer) { create(:answer, user: user, question: question) }
    let(:other_answer) { create(:answer, user: other, question: other_question) }
    let(:comment) { create(:comment, commentable: question, user: user) }
    let(:other_comment) { create(:comment, commentable: question, user: other) }
    let(:attachment) { create(:attachment, attachable: question) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :manage, question, user: user }
    it { should_not be_able_to :manage, other_question, user: user }

    it { should be_able_to :manage, answer, user: user }
    it { should_not be_able_to :manage, other_answer, user: user }

    it { should be_able_to :manage, comment, user: user }
    it { should_not be_able_to :manage, other_comment, user: user }

    it { should be_able_to :manage, attachment, user: user }
    it { should_not be_able_to :manage, create(:attachment) }

    it { should be_able_to :vote, other_question, user: user }
    it { should_not be_able_to :vote, question, user: user }
    it { should be_able_to :vote, other_answer, user: user }
    it { should_not be_able_to :vote, answer, user: user }

    it { should be_able_to :best_answer, create(:answer, question: question), user: user }
    it { should_not be_able_to :best_answer, create(:answer), user: user }

    it { should be_able_to :me, user, id: user }
    it { should be_able_to :profiles, User, user: user }
  end
end
