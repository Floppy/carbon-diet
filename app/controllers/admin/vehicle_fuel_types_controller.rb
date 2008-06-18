class Admin::VehicleFuelTypesController < Admin::AdminController
  
  active_scaffold :vehicle_fuel_types do |config|
    config.columns[:vehicle_fuel_class].ui_type = :select    
  end

end
