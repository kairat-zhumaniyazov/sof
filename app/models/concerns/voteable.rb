module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable, dependent: :destroy
  end

  def votes_sum
    votes.sum(:value)
  end

  def user_is_voted?(user)
    votes.find_by(user: user) ? true : false
  end

  def re_vote(user)
    vote = votes.find_by(user: user)
    if vote
      vote.destroy
      return true
    end
    false
  end

  def make_vote(value, user)
    user_vote = votes.create_with(user: user).find_or_create_by(user: user)
    if user_vote.value != value
      user_vote.update(value: value)
    end

    if self.is_a? Answer
      ReputationCalculator.calculate(self.user, value > 0 ? :vote_plus_to_answer : :vote_minus_to_answer)
    elsif self.is_a? Question
      ReputationCalculator.calculate(self.user, value > 0 ? :vote_plus_to_question : :vote_minus_to_question)
    end
  end
end
