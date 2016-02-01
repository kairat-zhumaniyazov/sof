class AddAnswersCountToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :answers_count, :integer, default: 0

    Question.find_each do |question|
      question.update_attribute(:answers_count, question.answers.count)
    end
  end
end
