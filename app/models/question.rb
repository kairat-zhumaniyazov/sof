class Question < ActiveRecord::Base
  include Attachable
  include Voteable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :followers, through: :subscriptions, source: :user
  belongs_to :user

  validates :title, :body, :user_id, presence: true

  scope :created_yesterday, -> { where(created_at: Date.yesterday.beginning_of_day..Date.yesterday.end_of_day) }
  default_scope -> { order(created_at: :desc) }

  after_create :subscribe_author

  def subscribe(user)
    followers << user unless followers.include? user
  end

  def unsubscribe(user)
    subscriptions.find_by(user_id: user).destroy if followers.include? user
  end

  private

  def subscribe_author
    followers << user
  end
end
