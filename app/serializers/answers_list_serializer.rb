class AnswersListSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :created_at, :updated_at
end
