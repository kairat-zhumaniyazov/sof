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
    SubscribersNotificationJob.perform_later(question)
  end

  def calculate_reputation
    ReputationCalculator.calculate(:new_answer, self, user)
  end

  def best_answer_reputation_calculate
    ReputationCalculator.calculate(:best_answer, self, user) if best_changed? && best
  end
end
