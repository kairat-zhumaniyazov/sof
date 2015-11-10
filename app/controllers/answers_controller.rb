class AnswersController < ApplicationController
  before_action :get_question, only: [:index, :new, :create]

  def new
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.build(answer_params)
    if @answer.save
      redirect_to question_path @question
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def get_question
    @question = Question.find(params[:question_id])
  end
end
