require File.dirname(__FILE__) + '/../spec_helper'

describe Vehicle do

  fixtures :users, :vehicles, :vehicle_fuel_purchases, :vehicle_fuel_types, :vehicle_fuel_classes, :vehicle_fuel_units

  it "old-style emissions calc should calculate emissions for period based on first purchase, not second" do
    # Load correct vehicle from fixtures
    vehicle = vehicles(:vehicle_for_emissions_test)
    vehicle.user.tester = false
    # Calculate emissions
    vehicle.vehicle_fuel_purchases.count.should be(3)
    emissions = vehicle.emissions
    # The first emissions period should use 4 litres per day, giving 4 kg of co2 per day
    emissions[0][:co2_per_day].should be_close(4, 1e-9)
    # The second emissions period should use 6 litres per day, giving 6 kg of co2 per day
    emissions[1][:co2_per_day].should be_close(6, 1e-9)
  end

  it "new-style emissions calc should calculate emissions for period based on first purchase, not second" do
    # Load correct vehicle from fixtures
    vehicle = vehicles(:vehicle_for_emissions_test)
    vehicle.user.tester = true
    # Calculate emissions
    vehicle.vehicle_fuel_purchases.count.should be(3)
    emissions = vehicle.emissions
    # The first emissions period should use 3 litres per day, giving 3 kg of co2 per day
    emissions[0][:co2_per_day].should be_close(3, 1e-9)
    # The second emissions period should use 8 litres per day, giving 8 kg of co2 per day
    emissions[1][:co2_per_day].should be_close(8, 1e-9)
  end

end