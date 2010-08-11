require File.dirname(__FILE__) + '/../spec_helper'

describe "FlightClass", ActiveSupport::TestCase do
  fixtures :flight_classes

  it "validation failure" do
    flight_class = FlightClass.new()
    flight_class.valid?.should == false
    flight_class = FlightClass.new(:name => "First class")
    flight_class.valid?.should == false
    flight_class = FlightClass.new(:scale_factor => 3.4)
    flight_class.valid?.should == false
  end

  it "validation success" do
    flight_class = FlightClass.new(:name => "First class", :scale_factor => 3.4)
    flight_class.valid?.should == true
  end

end
