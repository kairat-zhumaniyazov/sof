class Question < ActiveRecord::Base
  include Attachable
  include Voteable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :followers, through: :subscriptions, source: :user
  belongs_to :user

  validates :title, :body, :user_id, presence: true

  scope :created_yesterday, -> { where(created_at: Date.yesterday..Date.today) }

  after_create :subscribe_author

  private

  def subscribe_author
    followers << user if user
  end
end
