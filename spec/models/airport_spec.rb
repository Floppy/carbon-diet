require File.dirname(__FILE__) + '/../spec_helper'

describe "Airport", ActiveSupport::TestCase do
  fixtures :airports

  it "full description" do
    Airport.find(1).full_description.should == "EGKK / LGW: Gatwick, London, England"
    Airport.find(2).full_description.should == "EGPH / EDI: Edinburgh, UK"
    Airport.find(3).full_description.should == "LEAL / ALC: Alicante, Spain"
    Airport.find(4).full_description.should == "KLAX / LAX: Los Angeles International, Los Angeles, USA"
  end

  it "find by description" do
    Airport.find_by_full_description(Airport.find(1).full_description).id.should == 1
    Airport.find_by_full_description(Airport.find(2).full_description).id.should == 2
    Airport.find_by_full_description(Airport.find(3).full_description).id.should == 3
    Airport.find_by_full_description(Airport.find(4).full_description).id.should == 4
  end
  
  it "search on name" do
    airports = Airport.search("g");
    airports.length.should == 3
    airports = Airport.search("ga");
    airports.length.should == 1
    airports = Airport.search("gat");
    airports.length.should == 1
    airports = Airport.search("gatw");
    airports.length.should == 1
    airports = Airport.search("gatwi");
    airports.length.should == 1
    airports = Airport.search("gatwic");
    airports.length.should == 1
    airports = Airport.search("gatwick");
    airports.length.should == 1
    airports.first.should == Airport.find(1)
  end

  it "search on location" do
    airports = Airport.search("l");
    airports.length.should == 3
    airports = Airport.search("lo");
    airports.length.should == 2
    airports = Airport.search("lon");
    airports.length.should == 1
    airports = Airport.search("lond");
    airports.length.should == 1
    airports = Airport.search("londo");
    airports.length.should == 1
    airports = Airport.search("london");
    airports.length.should == 1
    airports.first.should == Airport.find(1)
  end

  it "search on country" do
    airports = Airport.search("u");
    airports.length.should == 2
    airports = Airport.search("us");
    airports.length.should == 1
    airports = Airport.search("usa");
    airports.length.should == 1
    airports.first.should == Airport.find(4)
  end

  it "search on iata code" do
    airports = Airport.search("l");
    airports.length.should == 3
    airports = Airport.search("lg");
    airports.length.should == 1
    airports = Airport.search("lgw");
    airports.length.should == 1
    airports.first.should == Airport.find(1)
  end

  it "search on icao code" do
    airports = Airport.search("e");
    airports.length.should == 4
    airports = Airport.search("eg");
    airports.length.should == 2
    airports = Airport.search("egk");
    airports.length.should == 1
    airports = Airport.search("egkk");
    airports.length.should == 1
    airports.first.should == Airport.find(1)
  end

end
