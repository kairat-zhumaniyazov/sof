class QuestionsController < ApplicationController
  include VoteableController

  before_action :authenticate_user!, only: [:new, :create, :destroy, :update]
  before_action :load_question, only: [:show, :destroy, :update]
  before_action :vote_for, only: [:vote_plus, :vote_minus]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
    @question.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to question_path @question
    else
      render :new
    end
  end

  def destroy
    if @question.user_id == current_user.id
      flash[:notice] = 'Your question deleted.'
      @question.destroy
    else
      flash[:alert] = 'You can not delete this question.'
    end
    redirect_to questions_path
  end

  def update
    @question.update(question_params)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def vote_for
    @vote_for_obj = Question.find(params[:id])
  end
end
