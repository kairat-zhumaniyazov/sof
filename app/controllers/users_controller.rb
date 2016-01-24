class UsersController < ApplicationController
  authorize_resource

  def show
    @user = User.find(params[:id])
    @last_questions = @user.questions.limit(5)
    @last_answers = @user.answers.limit(5)
  end

  def edit
    #code
  end
end
