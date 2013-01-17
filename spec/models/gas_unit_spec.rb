require 'spec_helper'

describe GasUnit do
  fixtures :gas_units

  it 'generates name with abbreviation string' do
    gas_units(:kWh).name_with_abbreviation.should == 'Kilowatt-Hours (kWh)'
  end

end
