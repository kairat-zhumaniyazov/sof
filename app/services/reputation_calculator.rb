class ReputationCalculator
  def self.calculate(user, action)
    case action
    when :new_answer
      value = 1
    when :first_answer_to_question
      value = 1
    when :answer_for_own_question
      value = 2
    when :best_answer
      value = 3
    when :vote_plus_to_answer
      value = 1
    when :vote_minus_to_answer
      value = -1
    when :vote_plus_to_question
      value = 2
    when :vote_minus_to_question
      value = -2
    else
      value = 0
    end

    user.update_attribute(:reputation, user.reputation + value) if value != 0
  end
end
