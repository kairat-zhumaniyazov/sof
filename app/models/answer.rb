class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true

  default_scope -> { order(best: :desc) }

  def make_best
    self.question.answers.update_all(best: false)
    self.update(best: true)
  end
end
