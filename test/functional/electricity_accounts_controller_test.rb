require File.dirname(__FILE__) + '/../test_helper'
require 'electricity_accounts_controller'

# Re-raise errors caught by the controller.
class ElectricityAccountsController; def rescue_action(e) raise e end; end

class ElectricityAccountsControllerTest < Test::Unit::TestCase
  fixtures :electricity_accounts

  def setup
    @controller = ElectricityAccountsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_truth
    assert true
  end
end
