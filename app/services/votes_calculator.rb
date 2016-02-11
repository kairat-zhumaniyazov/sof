class VotesCalculator
  def self.calculate_for(object, delta = 0)
    sql = "UPDATE #{object.class.name.pluralize.downcase} SET votes_sum = votes_sum + (#{delta}) WHERE id = #{object.id}"
    ActiveRecord::Base.connection.execute(sql) if object && delta != 0
  end
end
