FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@test.com"}
    sequence(:nickname) { |n| "nickname#{n}" }
    password '12345678'
    password_confirmation '12345678'
    confirmed_at Time.now
  end

end
