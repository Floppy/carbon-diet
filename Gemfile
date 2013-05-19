source 'http://rubygems.org'

gem 'rails', '~> 3.2.3'
gem 'active_scaffold'
gem 'airbrake'
gem 'validates_timeliness'
gem 'multipass'
gem 'will_paginate'
gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'
gem "recaptcha", :require => "recaptcha/rails"
gem "mini_magick"
gem 'whenever'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'sqlite3'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'spork-rails'
  gem 'guard-spork'
  gem 'growl'
  gem 'simplecov', :require => false
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'af'
  gem 'caldecott', '~> 0.0.5'
  gem 'poltergeist'
end

group :production do
  gem 'mysql2'
end