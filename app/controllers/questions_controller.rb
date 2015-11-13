class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :load_question, only: [:show, :destroy]
  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
  end

  def new
    @question = Question.new
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

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def load_question
    @question = Question.find(params[:id])
  end
end
