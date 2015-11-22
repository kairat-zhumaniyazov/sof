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
    if current_user.id != @vote_for_obj.user_id
      user_vote = @vote_for_obj.votes.create_with(user: current_user).find_or_create_by(user_id: current_user)
      user_vote.update(value: value) if user_vote.value != value
      render json: {
        votes_sum: @vote_for_obj.votes_sum,
        voted_to: @vote_for_obj.class.name,
        voted_to_id: @vote_for_obj.id
      }
    else
      render json: { status: :unprocessable_entity }
    end
  end
end
