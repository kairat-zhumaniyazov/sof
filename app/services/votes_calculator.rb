class VotesCalculator
  def self.calculate_for(object)
    object.update_attribute(:votes_sum, object.votes.sum(:value)) if object
  end
end
