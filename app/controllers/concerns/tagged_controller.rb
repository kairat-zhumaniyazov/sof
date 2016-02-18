module TaggedController
  extend ActiveSupport::Concern

  def tagged_list
    @questions = Question.where("'#{params[:tag]}' = ANY (tags)")
    respond_with @questions
  end
end
