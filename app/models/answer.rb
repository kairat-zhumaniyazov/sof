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

  def make_best
    ActiveRecord::Base.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      user.reputations.add(Reputation::FOR_THE_BEST_ANSWER)
    end
  end

  private

  def new_answer_notification
    SubscribersNotificationJob.perform_later(self.question)
  end

  def calculate_reputation
    user.reputations.add(Reputation::FOR_NEW_ANSWER_TO_ANOTHER_QUESTION)

    if question.answers.count == 1
      user.reputations.add(Reputation::FOR_FIRST_ANSWER_TO_QUESTION)
    end

    if question.user.id == user.id
      user.reputations.add(Reputation::FOR_ANSWER_TO_OWN_QUESTION)
    end
  end
end
