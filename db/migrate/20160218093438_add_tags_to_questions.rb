class AddTagsToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :tags, :text, array: true, default: []
    add_index :questions, :tags
  end
end
