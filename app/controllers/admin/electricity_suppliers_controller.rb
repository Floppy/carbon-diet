class Admin::ElectricitySuppliersController < Admin::AdminController
 
  active_scaffold :electricity_suppliers do |config|
    config.columns[:country].form_ui = :select
    config.list.columns = [:name, :country, :default]
    config.update.columns = [:name, :country, :default, :aliases, :company_url, :info_url, :electricity_supplier_sources]
  end

end
