class CommentsController < ApplicationController
  before_action :authenticate_user!, only: :create
  before_action :load_commentable, only: :create
  after_action :publish_new_comment, only: :create

  respond_to :js, only: :create

  authorize_resource

  def create
    @comment = @commentable.comments.create(comment_params.merge(user_id: current_user.id))
    respond_with(@comment)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def parse_commentable_class
    params[:comment][:commentable].classify.constantize
  end

  def parse_commentable_id
    case params[:comment][:commentable]
    when 'Question'
      params[:question_id]

    when 'Answer'
      params[:answer_id]
    end
  end

  def get_publish_channel(commentable)
    case commentable
    when Question
      "/questions/#{commentable.id}/answers"

    when Answer
      "/questions/#{commentable.question.id}/answers"
    end
  end

  def load_commentable
    @commentable = parse_commentable_class.find(parse_commentable_id)
  end

  def publish_new_comment
    return unless @comment.valid?
    PrivatePub.publish_to get_publish_channel(@commentable),
                          post: (
                            @comment.attributes.merge(
                              type: 'new_comment',
                              commentable_type: @commentable.class.name,
                              commentable_id: @commentable.id,
                              _html: render_to_string(
                                partial: 'comment', locals: { comment: @comment })
                            )).to_json
  end
end
