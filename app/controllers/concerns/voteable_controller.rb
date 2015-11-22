module VoteableController
  extend ActiveSupport::Concern
  def vote_plus
    vote(1)
  end

  def vote_minus
    vote(-1)
  end

  private

  def vote(value)
    user_vote = @vote_for_obj.votes.find_by(user_id: current_user)
    if current_user.id != @vote_for_obj.user_id && !user_vote
      @vote_for_obj.votes.create(user: current_user, value: value)
      render json: { votes_sum: @vote_for_obj.votes_sum, voted_to: @vote_for_obj.class.name, voted_to_id: @vote_for_obj.id }
    else
      render json: { status: :unprocessable_entity }
    end
  end
end
