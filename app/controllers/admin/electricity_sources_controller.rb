class Admin::ElectricitySourcesController < Admin::AdminController

  active_scaffold :electricity_sources do |config|
    config.columns = [:source, :country, :g_per_kWh]    
    config.columns[:country].ui_type = :select
  end

end
