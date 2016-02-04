module ApplicationHelper
  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end

  def comments_collection_cache_key_for(object)
    count = object.comments.count
    max_created_at = object.comments.maximum(:created_at).try(:utc).try(:to_s, :number)
    "#{object.class.to_s.downcase.pluralize}/comments_collection-#{count}-#{max_created_at}"
  end
end
