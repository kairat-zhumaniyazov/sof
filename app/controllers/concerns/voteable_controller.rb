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
    @voted_to.votes.create(user: current_user, value: value)
    render json: { votes_sum: @voted_to.votes.sum(:value), voted_to: @voted_to.class.name, voted_to_id: @voted_to.id }
  end
end
