class User < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :vkontakte, :twitter]

  accepts_nested_attributes_for :authorizations, reject_if: :all_blank, allow_destroy: true

  def confirm!
    #welcome_email
    super
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    if email = auth.info.email
      user = User.where(email: email).first
      unless user
        password = Devise.friendly_token[0, 20]
        user = User.create!(email: email, password: password, password_confirmation: password, confirmed_at: Time.now)
      end
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
      user
    else
      nil
    end
  end

  def self.create_with_psw(email)
    password = Devise.friendly_token[0, 20]
    User.create(email: email, password: password, password_confirmation: password)
  end

  private

  def welcome_email
    UserMailer.email_confirmation(self).deliver
  end
end
