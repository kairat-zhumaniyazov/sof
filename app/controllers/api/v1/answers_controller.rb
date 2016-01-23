class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource Answer

  before_action :load_question, only: [:index, :create]

  def index
    respond_with @question.answers, each_serializer: AnswersListSerializer
  end

  def show
    respond_with Answer.find(params[:id])
  end

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_resource_owner))
    respond_with @answer, location: question_answers_url(question_id: @question, id: @answer)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
