Factory.define :user do |u|
  u.login 'bob'
end

Factory.define :user_with_email, :class => 'user' do |u|
  u.login 'bob'
  u.email 'bob@example.com'
  u.confirmation_code 'code'
end
