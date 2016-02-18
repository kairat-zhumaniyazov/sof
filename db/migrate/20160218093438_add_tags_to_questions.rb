class AddTagsToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :tags, :text, array: true, default: [], index: true
  end
end
