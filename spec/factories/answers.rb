FactoryGirl.define do
  factory :answer do
    question nil
    body "MyText"
  end

  factory :invalid_answer, class: 'Answer' do
    question nil
    body nil
  end
end
