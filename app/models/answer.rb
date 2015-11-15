class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true

  def make_best
    self.question.answers.update_all(best: false)
    self.update(best: true)
  end
end
