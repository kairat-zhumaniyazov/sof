module ApplicationHelper
  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end

  def cache_key_for_question_with_author(question)
    "#{updated_at_to_s(question)}_author_#{question.user.id}_#{updated_at_to_s(question.user)}"
  end

  def updated_at_to_s(object)
    object.updated_at.try(:utc).try(:to_s, :number)
  end
end
