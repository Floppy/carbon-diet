require File.dirname(__FILE__) + '/../spec_helper'

describe "VehicleFuelType", ActiveSupport::TestCase do
  fixtures :vehicle_fuel_types
  fixtures :vehicle_fuel_classes

  it "relationships" do
    VehicleFuelType.find(1).vehicle_fuel_class.should_not be_nil
  end

end
