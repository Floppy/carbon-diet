require File.dirname(__FILE__) + '/../spec_helper'

describe "VehicleFuelClass", ActiveSupport::TestCase do
  fixtures :vehicle_fuel_classes
  fixtures :vehicle_fuel_types
  fixtures :countries

  it "relationships" do
    VehicleFuelClass.find(1).vehicle_fuel_types.should_not be_nil
    VehicleFuelClass.find(1).country.should_not be_nil
  end

end
