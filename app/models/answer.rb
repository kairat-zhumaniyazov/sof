class Answer < ActiveRecord::Base
  include Attachable
  include Voteable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true

  default_scope -> { order(best: :desc).order(created_at: :asc) }

  after_create :new_answer_notification
  after_create :calculate_reputation
  after_update :best_answer_reputation_calculate

  def make_best
    ActiveRecord::Base.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

  private

  def new_answer_notification
    SubscribersNotificationJob.perform_later(self.question)
  end

  def calculate_reputation
    ReputationCalculator.calculate(user, :new_answer)

    if question.answers.count == 1
      ReputationCalculator.calculate(user, :first_answer_to_question)
    end

    if question.user.id == user.id
      ReputationCalculator.calculate(user, :answer_for_own_question)
    end
  end

  def best_answer_reputation_calculate
    if best_changed?
      ReputationCalculator.calculate(self.user, :best_answer) if best
    end
  end
end
