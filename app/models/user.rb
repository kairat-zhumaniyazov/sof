class User < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribes, through: :subscriptions, source: :question

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :vkontakte, :twitter]

  accepts_nested_attributes_for :authorizations, reject_if: :all_blank, allow_destroy: true

  def confirm!
    super
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    if email = auth.info.email
      user = load_or_create_user(email)
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
      user
    end
  end

  def self.create_with_psw(email)
    password = Devise.friendly_token[0, 20]
    User.create(email: email,
                password: password,
                password_confirmation: password,
                confirmed_at: Time.zone.now)
  end

  private

  def self.load_or_create_user(email)
    user = User.find_by(email: email)
    user = create_with_psw(email) unless user
    user
  end

  def welcome_email
    UserMailer.email_confirmation(self).deliver_later
  end
end
