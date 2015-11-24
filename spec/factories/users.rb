FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@test.com"}
    password '12345678'
    password_confirmation '12345678'
  end

end
