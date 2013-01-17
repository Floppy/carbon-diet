require 'spec_helper'

describe ElectricityUnit do
  fixtures :electricity_units

  it 'generates name with abbreviation string' do
    electricity_units(:kWh).name_with_abbreviation.should == 'Kilowatt-Hours (kWh)'
  end

end
