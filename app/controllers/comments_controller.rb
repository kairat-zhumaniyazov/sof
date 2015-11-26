class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :load_commentable, only: [:create]

  def show
    @comment = Comment.find(params[:id])
    render partial: 'comment', locals: { comment: @comment }, layout: false
  end

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      respond_to do |format|
        format.js do
          PrivatePub.publish_to get_publish_channel(@commentable),
                                event: {
                                  type: 'new_comment',
                                  id: @comment.id,
                                  user_id: current_user.id,
                                  commentable_type: @commentable.class.name,
                                  commentable_id: @commentable.id
                                }.to_json
        end
      end
    else
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def get_commentable_class
    params[:comment][:commentable].classify.constantize
  end

  def get_commentable_id
    case params[:comment][:commentable]
    when 'Question'
      params[:question_id]

    when 'Answer'
      params[:answer_id]
    end
  end

  def get_publish_channel commentable
    case commentable
    when Question
      "/questions/#{commentable.id}/answers"

    when Answer
      "/questions/#{commentable.question.id}/answers"
    end
  end

  def load_commentable
    @commentable = get_commentable_class.find(get_commentable_id)
  end
end
