require File.dirname(__FILE__) + '/../test_helper'

class FlightTest < ActiveSupport::TestCase
  fixtures :flights
  fixtures :airports
  fixtures :flight_factors
  fixtures :flight_classes
  fixtures :users

  # Replace this with your real tests.
  def test_distances
    flight = Flight.find(1)
    assert flight.km.to_i == 574
    flight = Flight.find(2)
    assert flight.km.to_i == 1432
    flight = Flight.find(3)
    assert flight.km.to_i == 8807
    flight = Flight.find(4)
    assert flight.km.to_i == 8807
    flight = Flight.find(5)
    assert flight.km.to_i == 8807
    flight = Flight.find(6)
    assert flight.km.to_i == 17614
  end

  def test_emissions
    flight = Flight.find(1)
    assert flight.kg_of_co2.to_i == 258
    assert flight.kg_of_co2 == flight.km * 0.45
    flight = Flight.find(2)
    assert flight.kg_of_co2.to_i == 429
    assert flight.kg_of_co2 == flight.km * 0.30
    flight = Flight.find(3)
    assert flight.kg_of_co2.to_i == 2818
    assert flight.kg_of_co2 == flight.km * 0.32
  end

  def test_firstclass
    economy = Flight.find(3)
    firstclass = Flight.find(4)
    assert firstclass.km == economy.km
    assert firstclass.kg_of_co2 == economy.kg_of_co2 * 3.4
  end

  def test_twopeople
    oneperson = Flight.find(3)
    twopeople = Flight.find(5)
    assert twopeople.km == oneperson.km
    assert twopeople.kg_of_co2 == oneperson.kg_of_co2 * 2
  end

  def test_return
    oneway = Flight.find(3)
    bothways = Flight.find(6)
    assert oneway.return_on.nil?
    assert !(bothways.return_on.nil?)
    assert bothways.km == oneway.km * 2
    assert bothways.kg_of_co2 == oneway.kg_of_co2 * 2
  end

  def test_graph_data_oneway_flight
    user = User.find(1)
    flight = Flight.find(1)
    outbound_on = 1.week.ago
    kg = flight.kg_of_co2
    emissiondata = user.flight_emissions
    rawgraph = emissiondata.calculate_graph(30)
    assert value_in_graph(rawgraph, outbound_on - 1.day).nil? 
    value = value_in_graph(rawgraph, outbound_on)
    assert value
    assert value == kg
    assert value_in_graph(rawgraph, outbound_on + 1.day).nil?    
  end

  def test_graph_data_return_flight
    user = User.find(1)
    flight = Flight.find(6)
    outbound_on = 7.weeks.ago
    return_on = 6.weeks.ago
    kg = flight.kg_of_co2 / 8.0
    emissiondata = user.flight_emissions
    rawgraph = emissiondata.calculate_graph(90)
    assert value_in_graph(rawgraph, outbound_on - 1.day).nil? 
    value = value_in_graph(rawgraph, outbound_on) 
    assert value 
    assert value == kg 
    assert value_in_graph(rawgraph, outbound_on + 1.day) 
    assert value_in_graph(rawgraph, return_on - 1.day) 
    assert value_in_graph(rawgraph, return_on)
    assert value_in_graph(rawgraph, return_on) == kg
    assert value_in_graph(rawgraph, return_on + 1.day).nil? 
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
