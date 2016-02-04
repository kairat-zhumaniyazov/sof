module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable, dependent: :destroy
  end

  def user_is_voted?(user)
    votes.find_by(user: user) ? true : false
  end

  def re_vote(user)
    vote = votes.find_by(user: user)
    if vote
      self.votes_sum -= vote.value
      vote.destroy
      return true
    end
    false
  end

  def make_vote(value, user)
    user_vote = votes.create_with(user: user).find_or_create_by(user: user)
    user_vote.update(value: value) if user_vote.value != value
    self.votes_sum += value

    ReputationCalculator.calculate(:vote, self, user, value: value)

  end
end
