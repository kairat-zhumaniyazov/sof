class AnswersController < ApplicationController
  before_action :get_question, only: [:index, :new]

  def new
    @answer = @question.answers.build
  end

  private

  def get_question
    @question = Question.find(params[:question_id])
  end
end
