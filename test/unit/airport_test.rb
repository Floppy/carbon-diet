require File.dirname(__FILE__) + '/../test_helper'

class AirportTest < ActiveSupport::TestCase
  fixtures :airports

  def test_full_description
    assert Airport.find(1).full_description == "EGKK / LGW: Gatwick, London, England"
    assert Airport.find(2).full_description == "EGPH / EDI: Edinburgh, UK"
    assert Airport.find(3).full_description == "LEAL / ALC: Alicante, Spain"
    assert Airport.find(4).full_description == "KLAX / LAX: Los Angeles International, Los Angeles, USA"
  end

  def test_find_by_description
    assert Airport.find_by_full_description(Airport.find(1).full_description).id == 1
    assert Airport.find_by_full_description(Airport.find(2).full_description).id == 2
    assert Airport.find_by_full_description(Airport.find(3).full_description).id == 3
    assert Airport.find_by_full_description(Airport.find(4).full_description).id == 4
  end
  
  def test_search_on_name
    airports = Airport.search("g");
    assert airports.length == 3
    airports = Airport.search("ga");
    assert airports.length == 1
    airports = Airport.search("gat");
    assert airports.length == 1
    airports = Airport.search("gatw");
    assert airports.length == 1
    airports = Airport.search("gatwi");
    assert airports.length == 1
    airports = Airport.search("gatwic");
    assert airports.length == 1
    airports = Airport.search("gatwick");
    assert airports.length == 1
    assert airports.first == Airport.find(1)
  end

  def test_search_on_location
    airports = Airport.search("l");
    assert airports.length == 3
    airports = Airport.search("lo");
    assert airports.length == 2
    airports = Airport.search("lon");
    assert airports.length == 1
    airports = Airport.search("lond");
    assert airports.length == 1
    airports = Airport.search("londo");
    assert airports.length == 1
    airports = Airport.search("london");
    assert airports.length == 1
    assert airports.first == Airport.find(1)
  end

  def test_search_on_country
    airports = Airport.search("u");
    assert airports.length == 2
    airports = Airport.search("us");
    assert airports.length == 1
    airports = Airport.search("usa");
    assert airports.length == 1
    assert airports.first == Airport.find(4)
  end

  def test_search_on_iata_code
    airports = Airport.search("l");
    assert airports.length == 3
    airports = Airport.search("lg");
    assert airports.length == 1
    airports = Airport.search("lgw");
    assert airports.length == 1
    assert airports.first == Airport.find(1)
  end

  def test_search_on_icao_code
    airports = Airport.search("e");
    assert airports.length == 4
    airports = Airport.search("eg");
    assert airports.length == 2
    airports = Airport.search("egk");
    assert airports.length == 1
    airports = Airport.search("egkk");
    assert airports.length == 1
    assert airports.first == Airport.find(1)
  end

end
