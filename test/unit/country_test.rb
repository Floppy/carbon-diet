require File.dirname(__FILE__) + '/../test_helper'

class CountryTest < ActiveSupport::TestCase
  fixtures :countries

  def test_validation_failure
    country = Country.new
    assert country.valid? == false
    country = Country.new(:name => "test")
    assert country.valid? == false
    country = Country.new(:abbreviation => "test")
    assert country.valid? == false
  end

  def test_validation_success
    country = Country.new(:name => "test", :abbreviation => "test")
    assert country.valid? == true
  end

  def test_list
    list = Country.list
    assert list.size == 3
    assert list[0].name == "-- Other --"
    assert list[1].name == "United Kingdom"
    assert list[2].name == "United States"
  end

end
