require 'spec_helper'

describe Vehicle do

  fixtures :users, :vehicles, :vehicle_fuel_purchases, :vehicle_fuel_types, :vehicle_fuel_classes, :vehicle_fuel_units

  it "emissions calc should calculate emissions for period based on first purchase, not second" do
    # Load correct vehicle from fixtures
    vehicle = vehicles(:vehicle_for_emissions_test)
    # Calculate emissions
    vehicle.vehicle_fuel_purchases.count.should be(3)
    emissions = vehicle.emissions
    # The first emissions period should use 3 litres per day, giving 3 kg of co2 per day
    emissions[0][:co2_per_day].should be_within(1e-9).of(3)
    # The second emissions period should use 8 litres per day, giving 8 kg of co2 per day
    emissions[1][:co2_per_day].should be_within(1e-9).of(8)
  end

  it "should provide access to date of most recent data" do
    vehicles(:vehicle_for_emissions_test).date_of_newest_data.should == 1.day.ago.to_date
  end

  it "should have a sensible default for date of most recent data" do
    vehicles(:vehicle_with_no_purchases).date_of_newest_data.should == 100.years.ago.to_date
  end

end