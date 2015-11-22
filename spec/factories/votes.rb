FactoryGirl.define do
  factory :vote_for_question, class: 'Vote' do
    user
    association :voteable, factory: :question
    value 0
  end

end
