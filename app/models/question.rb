class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments, as: :attachable

  validates :title, :body, :user_id, presence: true
end
