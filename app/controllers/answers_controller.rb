class AnswersController < ApplicationController
  include VoteableController

  before_action :authenticate_user!
  before_action :get_question, only: [:create, :update, :best_answer]
  before_action :get_answer, only: [:destroy, :update, :best_answer, :show]
  after_action  :publish_new_answer, only: :create

  respond_to :js, only: [:create, :destroy, :update, :best_answer]

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user_id: current_user.id)))
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def best_answer
    respond_with @answer.make_best if current_user.id == @question.user_id
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

  def publish_new_answer
    if @answer.valid?
      PrivatePub.publish_to "/questions/#{@question.id}/answers",
                            post: { type: 'new_answer',
                                    _html: render_to_string(partial: 'answer', locals: { answer: @answer }) }.to_json
    end
  end
end
