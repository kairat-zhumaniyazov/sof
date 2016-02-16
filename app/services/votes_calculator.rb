class VotesCalculator
  def self.calculate_for(object, delta)
    object.class.where(id: object.id)
      .update_all("votes_sum = votes_sum + (#{delta})") if delta && delta != 0
  end
end
