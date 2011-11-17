Airbrake.configure do |config|
  config.api_key = (APP_CONFIG['airbrake']||APP_CONFIG['hoptoad'])['api_key']
end
