class AnswersController < ApplicationController
  include VoteableController

  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :get_question, only: [:create]
  before_action :get_answer, only: [:destroy, :update, :best_answer]
  before_action :voted_object, only: [:vote_plus, :vote_minus]

  def create
    @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))
  end

  def destroy
    @answer.destroy if @answer.user_id == current_user.id
  end

  def update
    @question = @answer.question
    @answer.update(answer_params)
  end

  def best_answer
    @question = @answer.question
    @answer.make_best if @question.user_id == current_user.id
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def get_question
    @question = Question.find(params[:question_id])
  end

  def get_answer
    @answer = Answer.find(params[:id])
  end

  def voted_object
    @voted_to = Answer.find(params[:id])
  end
end
