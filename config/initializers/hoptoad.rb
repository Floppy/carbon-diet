HOPTOAD_CONFIG_FILE = "#{RAILS_ROOT}/config/hoptoad.yml"
if File.exist?(HOPTOAD_CONFIG_FILE)
  HoptoadNotifier.configure do |config|
    config.api_key = YAML.load_file(HOPTOAD_CONFIG_FILE)['api_key']
  end
end