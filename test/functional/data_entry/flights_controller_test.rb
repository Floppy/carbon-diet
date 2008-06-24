require File.dirname(__FILE__) + '/../../test_helper'
require 'data_entry/flights_controller'

# Re-raise errors caught by the controller.
class DataEntry::FlightsController; def rescue_action(e) raise e end; end

class DataEntry::FlightsControllerTest < Test::Unit::TestCase
  def setup
    @controller = DataEntry::FlightsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_truth
    assert true
  end
end
