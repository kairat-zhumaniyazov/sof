class ReputationCalculator
  def self.calculate(action, object, user, *args)
    self.send(action, object, user, *args)
  end

  private

  def self.new_answer(answer, user)
    return unless answer
    update(user, 1)

    if answer.question.answers.count == 1
      update(user, 1)
    end

    if answer.question.user.id == user.id
      update(user, 2)
    end
  end

  def self.vote(object, user, *args)
    return false unless value = args[0][:value].to_i
    if object.is_a? Answer
      update(object.user, value > 0 ? 1 : -1)
    end
  end

  def self.best_answer(answer, user)
    update(user, 3)
  end

  def self.update(user, value)
    user.update_attribute(:reputation, user.reputation + value)
  end
end
