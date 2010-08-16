require File.dirname(__FILE__) + '/../spec_helper'

describe "VehicleFuelType", ActiveSupport::TestCase do
  fixtures :vehicle_fuel_types
  fixtures :vehicle_fuel_classes

  it "relationships" do
    vehicle_fuel_types(:unleaded_uk).vehicle_fuel_class.should == vehicle_fuel_classes(:unleaded_uk)
  end

end
