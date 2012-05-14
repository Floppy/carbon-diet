FactoryGirl.define do

  factory :user do
    login { Faker::Internet.user_name }
  end

  factory :user_with_email, :class => 'user' do
    login { Faker::Internet.user_name.gsub('.','') }
    email { Faker::Internet.email }
    confirmation_code { SecureRandom.hex }
  end

end