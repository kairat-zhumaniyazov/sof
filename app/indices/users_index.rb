ThinkingSphinx::Index.define :user, with: :active_record do
  # fields
  indexes email, as: :author, sortable: true
end
