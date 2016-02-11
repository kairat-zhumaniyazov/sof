class Vote < ActiveRecord::Base
  belongs_to :voteable, polymorphic: true
  belongs_to :user

  validates :user_id, :value, :voteable_id, presence: true

  after_create :calculate_sum_create
  after_destroy :calculate_sum_destroy
  after_update :calculate_sum_update

  private

  def calculate_sum_create
    VotesCalculator.calculate_for(voteable, value)
  end

  def calculate_sum_destroy
    VotesCalculator.calculate_for(voteable, value * -1)
  end

  def calculate_sum_update
    VotesCalculator.calculate_for(voteable, value * 2)
  end
end
