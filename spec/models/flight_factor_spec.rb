require 'spec_helper'

describe "FlightFactor", ActiveSupport::TestCase do
  fixtures :flight_factors

  # Replace this with your real tests.
  it "find by distance" do
    # Domestic
    factor = FlightFactor.find_by_distance(500);
    factor.g_per_km.should == 450
    # Short Haul
    factor = FlightFactor.find_by_distance(1500);
    factor.g_per_km.should == 300
    # Long haul
    factor = FlightFactor.find_by_distance(10000);
    factor.g_per_km.should == 320
    # Domestic/Short boundary
    factor = FlightFactor.find_by_distance(1000);
    factor.g_per_km.should == 300
    # Short/Long boundary
    factor = FlightFactor.find_by_distance(5000);
    factor.g_per_km.should == 320
    # Zero
    factor = FlightFactor.find_by_distance(0);
    factor.g_per_km.should == 450
    # Moon
    factor = FlightFactor.find_by_distance(384400);
    factor.g_per_km.should == 320
  end
end
