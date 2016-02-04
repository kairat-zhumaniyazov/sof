class Vote < ActiveRecord::Base
  belongs_to :voteable, polymorphic: true
  belongs_to :user

  validates :user_id, :value, :voteable_id, presence: true

  after_create :calculate_sum
  after_destroy :calculate_sum
  after_update :calculate_sum

  private

  def calculate_sum
    VotesCalculator.calculate_for(voteable)
  end
end
