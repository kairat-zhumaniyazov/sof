class Reputation < ActiveRecord::Base
  belongs_to :user

  FOR_NEW_ANSWER_TO_ANOTHER_QUESTION = 1
  FOR_FIRST_ANSWER_TO_QUESTION = 1
  FOR_ANSWER_TO_OWN_QUESTION = 2
  FOR_THE_BEST_ANSWER = 3
  FOR_VOTE_PLUS_TO_ANSWER = 1
  FOR_VOTE_MINUS_TO_ANSWER = -1
  FOR_VOTE_PLUS_TO_QUESTION = 2
  FOR_VOTE_MINUS_TO_QUESTION = -2

  def self.add(value)
    create(value: value)
  end
end
