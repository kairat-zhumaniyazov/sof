class QuestionsController < ApplicationController
  include VoteableController

  before_action :authenticate_user!, only: [:new, :create, :destroy, :update]
  before_action :load_question, only: [:show, :destroy, :update, :subscribe, :unsubscribe]
  before_action :build_answer, only: :show
  after_action :publish_new_question, only: :create

  respond_to :html
  respond_to :js, only: [:update, :subscribe, :unsubscribe]

  authorize_resource

  def index
    respond_with(@questions = Question.with_votes_sum_and_answers_count)
  end

  def show
    gon.current_user_id = current_user.id if current_user
    respond_with @question
  end

  def new
    respond_with @question = Question.new
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def destroy
    @question.destroy if @question.user_id == current_user.id
    respond_with @question
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def subscribe
    respond_with @question.subscribe(current_user)
  end

  def unsubscribe
    respond_with @question.unsubscribe(current_user)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def publish_new_question
    return unless @question.valid?
    PrivatePub.publish_to '/questions', question: render_to_string(
      partial: 'question',
      locals: { question: @question })
  end

  def build_answer
    @answer = @question.answers.build
  end
end
