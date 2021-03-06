FactoryGirl.define do

  factory :user do
    login { Faker::Internet.user_name.gsub('.','').gsub('_','').gsub(' ','') }
  end

  factory :user_with_email, :class => 'user' do
    login { Faker::Internet.user_name.gsub('.','').gsub('_','').gsub(' ','') }
    email { Faker::Internet.email }
    confirmation_code { SecureRandom.hex }
  end

end