module TaggedController
  extend ActiveSupport::Concern

  def tagged_list
    respond_with @questions = Question.all_tags(params[:tag].split('+'))
  end
end
