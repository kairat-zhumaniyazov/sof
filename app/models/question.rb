class Question < ActiveRecord::Base
  include Attachable
  include Voteable
  include Commentable

  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, :user_id, presence: true
end
