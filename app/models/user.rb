class User < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribes, through: :subscriptions, source: :question

  mount_uploader :avatar, AvatarUploader

  validates :nickname, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9.\-_]+\z/ }

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
      user = load_or_create_user(auth)
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
      user
    end
  end

  def self.create_with_psw(email, nickname, avatar_url = nil)
    password = Devise.friendly_token[0, 20]
    user = User.create(email: email,
                       nickname: nickname,
                       remote_avatar_url: avatar_url,
                       password: password,
                       password_confirmation: password,
                       confirmed_at: Time.zone.now)

    user.persisted? ? user : nil
  end

  private

  # rubocop:disable Metrics/AbcSize
  def self.nickname_from_auth_hash(auth)
    if auth.info.nickname
      nickname = I18n.transliterate(auth.info.nickname)
    elsif auth.info.first_name || auth.info.last_name
      nickname = I18n.transliterate("#{auth.info.first_name}_#{auth.info.last_name}")
    else
      nickname = auth.info.email.tr('@', '_')
    end
  end

  def self.load_or_create_user(auth)
    user = User.find_by(email: auth.info.email)
    user = create_with_psw(auth.info.email,
                           nickname_from_auth_hash(auth),
                           auth.info.image) unless user
    user
  end

  def welcome_email
    UserMailer.email_confirmation(self).deliver_later
  end
end
