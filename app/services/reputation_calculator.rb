class ReputationCalculator
  def self.calculate(action, object, user, *args)
    send(action, object, user, *args)
  end

  def self.new_answer(answer, user)
    return unless answer
    update_reputation(user, 1)

    update_reputation(user, 1) if answer.question.answers.count == 1

    update_reputation(user, 2) if answer.question.user.id == user.id
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def self.vote(object, _user, *args)
    value = args[0][:value].to_i
    return false if !value || value == 0

    case object
    when Answer
      update_reputation(object.user, value > 0 ? 1 : -1)
    when Question
      update_reputation(object.user, value > 0 ? 2 : -2)
    end
  end

  def self.best_answer(_answer, user)
    update_reputation(user, 3)
  end

  def self.update_reputation(user, value)
    user.with_lock do
      user.update_attribute(:reputation, user.reputation + value)
    end
  end
end
