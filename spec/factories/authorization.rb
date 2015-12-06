FactoryGirl.define do
  factory :auth_twitter, class: 'Authorization' do
    provider 'twitter'
    uid '123123123'
  end

end
