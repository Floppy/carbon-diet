require 'spec_helper'

describe "Flight", ActiveSupport::TestCase do
  fixtures :flights
  fixtures :airports
  fixtures :flight_factors
  fixtures :flight_classes
  fixtures :users

  # Replace this with your real tests.
  it "distances" do
    flight = Flight.find(1)
    flight.km.to_i.should == 574
    flight = Flight.find(2)
    flight.km.to_i.should == 1432
    flight = Flight.find(3)
    flight.km.to_i.should == 8807
    flight = Flight.find(4)
    flight.km.to_i.should == 8807
    flight = Flight.find(5)
    flight.km.to_i.should == 8807
    flight = Flight.find(6)
    flight.km.to_i.should == 17614
  end

  it "emissions" do
    flight = Flight.find(1)
    flight.kg_of_co2.to_i.should == 258
    flight.kg_of_co2.should == flight.km * 0.45
    flight = Flight.find(2)
    flight.kg_of_co2.to_i.should == 429
    flight.kg_of_co2.should == flight.km * 0.30
    flight = Flight.find(3)
    flight.kg_of_co2.to_i.should == 2818
    flight.kg_of_co2.should == flight.km * 0.32
  end

  it "firstclass" do
    economy = Flight.find(3)
    firstclass = Flight.find(4)
    firstclass.km.should == economy.km
    firstclass.kg_of_co2.should == economy.kg_of_co2 * 3.4
  end

  it "twopeople" do
    oneperson = Flight.find(3)
    twopeople = Flight.find(5)
    twopeople.km.should == oneperson.km
    twopeople.kg_of_co2.should == oneperson.kg_of_co2 * 2
  end

  it "return" do
    oneway = Flight.find(3)
    bothways = Flight.find(6)
    oneway.return_on.nil?.should_not be_nil
    (bothways.return_on.nil?).should_not == true
    bothways.km.should == oneway.km * 2
    bothways.kg_of_co2.should == oneway.kg_of_co2 * 2
  end

  it "graph data oneway flight" do
    user = User.find(1)
    flight = Flight.find(1)
    outbound_on = 1.week.ago
    kg = flight.kg_of_co2
    emissiondata = user.flight_emissions
    rawgraph = emissiondata.calculate_graph(30)
    value_in_graph(rawgraph, outbound_on - 1.day).should be_nil
    value = value_in_graph(rawgraph, outbound_on)
    value.should_not be_nil
    value.should == kg
    value_in_graph(rawgraph, outbound_on + 1.day).should be_nil
  end

  it "graph data return flight" do
    user = User.find(1)
    flight = Flight.find(6)
    outbound_on = 7.weeks.ago
    return_on = 6.weeks.ago
    kg = flight.kg_of_co2 / 8.0
    emissiondata = user.flight_emissions
    rawgraph = emissiondata.calculate_graph(90)
    value_in_graph(rawgraph, outbound_on - 1.day).nil? .should_not be_nil
    value = value_in_graph(rawgraph, outbound_on) 
    value .should_not be_nil
    value.should == kg 
    value_in_graph(rawgraph, outbound_on + 1.day).should_not be_nil
    value_in_graph(rawgraph, return_on - 1.day).should_not be_nil
    value_in_graph(rawgraph, return_on).should_not be_nil
    value_in_graph(rawgraph, return_on).should == kg
    value_in_graph(rawgraph, return_on + 1.day).nil? .should_not be_nil
  end

private

  def value_in_graph(array,date)
    return array[:values][index_in_graph(array,date)]
  end

  def index_in_graph(array,date)
    strdate = Date::ABBR_MONTHNAMES[date.month] + " " + date.day.to_s
    array[:dates].index(strdate)
  end

end
