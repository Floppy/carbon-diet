require File.dirname(__FILE__) + '/../spec_helper'

describe "VehicleFuelClass", ActiveSupport::TestCase do
  fixtures :vehicle_fuel_classes
  fixtures :vehicle_fuel_types
  fixtures :countries

  it "relationships" do
    vehicle_fuel_classes(:unleaded_uk).vehicle_fuel_types.should_not be_nil
    vehicle_fuel_classes(:unleaded_uk).country.should_not be_nil
  end

end
