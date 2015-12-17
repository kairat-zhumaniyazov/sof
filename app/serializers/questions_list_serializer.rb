class QuestionsListSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title, :user_id

  has_many :answers

  def short_title
    object.title.truncate(10)
  end
end
