class AddVotesSumToQuestionsAndAnswers < ActiveRecord::Migration
  def change
    add_column :questions, :votes_sum, :integer, null: false, default: 0
    add_column :answers, :votes_sum, :integer, null: false, default: 0

    Question.find_each do |question|
      question.update_attribute(:votes_sum, question.votes.sum(:value))
    end

    Answer.find_each do |answer|
      answer.update_attribute(:votes_sum, answer.votes.sum(:value))
    end
  end
end
