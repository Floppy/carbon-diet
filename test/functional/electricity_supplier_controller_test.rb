require File.dirname(__FILE__) + '/../test_helper'
require 'electricity_supplier_controller'

# Re-raise errors caught by the controller.
class ElectricitySupplierController; def rescue_action(e) raise e end; end

class ElectricitySupplierControllerTest < Test::Unit::TestCase
  def setup
    @controller = ElectricitySupplierController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

end
