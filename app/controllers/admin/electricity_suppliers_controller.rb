class Admin::ElectricitySuppliersController < Admin::AdminController
 
  active_scaffold :electricity_suppliers do |config|
    config.columns[:country].form_ui = :select
    config.list.columns = [:name, :country, :g_per_kWh, :default]
    config.update.columns = [:name, :country, :default, :aliases, :company_url, :info_url, :g_per_kWh, :electricity_supplier_sources]
  end

end
