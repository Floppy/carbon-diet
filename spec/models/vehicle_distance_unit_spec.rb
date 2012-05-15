require 'spec_helper'

describe VehicleDistanceUnit do
  fixtures :vehicle_distance_units

  it 'generates name with abbreviation string' do
    vehicle_distance_units(:km).name_with_abbreviation.should == 'Kilometres (km)'
  end

end
