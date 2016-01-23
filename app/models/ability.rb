class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  # rubocop:disable Metrics/AbcSize
  def user_abilities
    guest_abilities
    can :manage, [Question, Answer, Comment], user: user
    can :manage, Attachment, attachable: { user_id: user.id }

    alias_action :vote_plus, :vote_minus, :re_vote, to: :vote
    can :vote, [Question, Answer]
    cannot :vote, [Question, Answer], user: user

    can :best_answer, Answer, question: { user_id: user.id }

    can :me, user, id: user.id
    can :profiles, User, user: user

    can :subscribe, Question do |question|
      !question.followers.include? user
    end

    can :unsubscribe, Question do |question|
      question.followers.include? user
    end
  end
end
