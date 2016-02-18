class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id, :created_at, :updated_at, :tags,
             :votes_sum, :answers_count

  has_many :answers
  has_many :attachments
  has_many :comments
end
