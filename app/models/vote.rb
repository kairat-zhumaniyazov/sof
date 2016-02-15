class Vote < ActiveRecord::Base
  belongs_to :voteable, polymorphic: true
  belongs_to :user

  attr_accessor :delta

  validates :user_id, :value, :voteable_id, presence: true

  after_commit :calculate_sum, on: [:create, :update, :destroy]
  after_create :delta_after_create
  before_update :delta_after_update
  after_destroy :delta_after_destroy

  private

  def delta_after_create
    self.delta = value
  end

  def delta_after_update
    self.delta = value_changed? ? value_change.last - value_change.first : 0
  end

  def delta_after_destroy
    self.delta = value * -1
  end

  def calculate_sum
    VotesCalculator.calculate_for(voteable, delta) if delta && delta != 0
  end
end
