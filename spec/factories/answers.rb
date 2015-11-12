FactoryGirl.define do
  sequence :body do |n|
    "Answer #{n}"
  end

  factory :answer do
    question nil
    body
  end

  factory :invalid_answer, class: 'Answer' do
    question nil
    body nil
  end
end
