class Answer < ActiveRecord::Base
  belongs_to :question

  validates :body, :question_id, presence: true
end
