class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true

  default_scope -> { order(best: :desc) }

  def make_best
    old_best = question.answers.where(best: true).first
    question.answers.update_all(best: false)
    if !update(best: true) && old_best
      old_best.update(best: true)
    end
  end
end
