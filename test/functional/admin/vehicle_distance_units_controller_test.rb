require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/vehicle_distance_units_controller'

# Re-raise errors caught by the controller.
class Admin::VehicleDistanceUnitsController; def rescue_action(e) raise e end; end

class Admin::VehicleDistanceUnitsControllerTest < Test::Unit::TestCase
  def setup
    @controller = Admin::VehicleDistanceUnitsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index_access
    get :index
    assert_response 401 # Access denied
  end

  def test_list_access
    get :list
    assert_response 401 # Access denied
  end

  def test_edit_access
    get :edit, :id => 1
    assert_response 401 # Access denied
  end

  def test_destroy_access
    get :destroy, :id => 1
    assert_response 401 # Access denied
  end

end
