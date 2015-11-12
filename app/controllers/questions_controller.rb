class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create ]

  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to question_path @question
    else
      render :new
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
