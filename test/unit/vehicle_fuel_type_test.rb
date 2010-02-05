require File.dirname(__FILE__) + '/../test_helper'

class VehicleFuelTypeTest < ActiveSupport::TestCase
  fixtures :vehicle_fuel_types
  fixtures :vehicle_fuel_classes

  def test_relationships
    assert VehicleFuelType.find(1).vehicle_fuel_class
  end

end
