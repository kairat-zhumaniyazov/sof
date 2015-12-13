class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id, :created_at, :updated_at

  has_many :answers
  has_many :attachments
  has_many :comments
end
