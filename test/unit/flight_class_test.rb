require File.dirname(__FILE__) + '/../test_helper'

class FlightClassTest < Test::Unit::TestCase
  fixtures :flight_classes

  def test_validation_failure
    flight_class = FlightClass.new()
    assert flight_class.valid? == false
    flight_class = FlightClass.new(:name => "First class")
    assert flight_class.valid? == false
    flight_class = FlightClass.new(:scale_factor => 3.4)
    assert flight_class.valid? == false
  end

  def test_validation_success
    flight_class = FlightClass.new(:name => "First class", :scale_factor => 3.4)
    assert flight_class.valid? == true
  end

end
