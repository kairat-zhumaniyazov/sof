class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource  class: Answer
  before_action :load_question, only: [:index, :show]

  def index
    respond_with @question.answers, each_serializer: AnswersListSerializer
  end

  def show
    respond_with @question.answers.where(id: params[:id]).first
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end
end
