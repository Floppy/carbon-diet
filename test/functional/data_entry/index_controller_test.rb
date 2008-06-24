require File.dirname(__FILE__) + '/../../test_helper'
require 'data_entry/index_controller'

# Re-raise errors caught by the controller.
class DataEntry::IndexController; def rescue_action(e) raise e end; end

class DataEntry::IndexControllerTest < Test::Unit::TestCase
  def setup
    @controller = DataEntry::IndexController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_truth
    assert true
  end
end
