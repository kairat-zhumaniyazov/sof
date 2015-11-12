class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [ :create, :destroy ]
  before_action :get_question, only: [:index, :new, :create, :destroy ]

  def new
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to question_path @question
    else
      render :new
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if @answer.user == current_user
      @answer.destroy
      flash[:notice] = 'Your answer deleted.'
    else
      flash[:alert] = 'You can not delete this answer.'
    end
    redirect_to question_path @question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def get_question
    @question = Question.find(params[:question_id])
  end
end
