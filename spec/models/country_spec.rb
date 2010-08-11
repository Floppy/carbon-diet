require File.dirname(__FILE__) + '/../spec_helper'

describe "Country", ActiveSupport::TestCase do
  fixtures :countries

  it "validation failure" do
    country = Country.new
    country.valid?.should == false
    country = Country.new(:name => "test")
    country.valid?.should == false
    country = Country.new(:abbreviation => "test")
    country.valid?.should == false
  end

  it "validation success" do
    country = Country.new(:name => "test", :abbreviation => "test")
    country.valid?.should == true
  end

  it "list" do
    list = Country.list
    list.size.should == 3
    list[0].name.should == "-- Other --"
    list[1].name.should == "United Kingdom"
    list[2].name.should == "United States"
  end

end
