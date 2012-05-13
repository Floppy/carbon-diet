Recaptcha.configure do |config|
  config.public_key  = ENV['RECAPTCHA_PUBLIC_KEY'] || APP_CONFIG['recaptcha']['public_key']
  config.private_key = ENV['RECAPTCHA_PRIVATE_KEY'] || APP_CONFIG['recaptcha']['private_key']
end