require File.dirname(__FILE__) + '/../test_helper'

class VehicleFuelClassTest < Test::Unit::TestCase
  fixtures :vehicle_fuel_classes
  fixtures :vehicle_fuel_types
  fixtures :countries

  def test_relationships
    assert VehicleFuelClass.find(1).vehicle_fuel_types
    assert VehicleFuelClass.find(1).country
  end

end
