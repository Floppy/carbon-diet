require File.dirname(__FILE__) + '/../test_helper'

class FlightFactorTest < ActiveSupport::TestCase
  fixtures :flight_factors

  # Replace this with your real tests.
  def test_find_by_distance
    # Domestic
    factor = FlightFactor.find_by_distance(500);
    assert factor.g_per_km == 450
    # Short Haul
    factor = FlightFactor.find_by_distance(1500);
    assert factor.g_per_km == 300
    # Long haul
    factor = FlightFactor.find_by_distance(10000);
    assert factor.g_per_km == 320
    # Domestic/Short boundary
    factor = FlightFactor.find_by_distance(1000);
    assert factor.g_per_km == 300
    # Short/Long boundary
    factor = FlightFactor.find_by_distance(5000);
    assert factor.g_per_km == 320
    # Zero
    factor = FlightFactor.find_by_distance(0);
    assert factor.g_per_km == 450
    # Moon
    factor = FlightFactor.find_by_distance(384400);
    assert factor.g_per_km == 320
  end
end
