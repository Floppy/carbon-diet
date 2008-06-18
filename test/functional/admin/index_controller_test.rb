require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/index_controller'

# Re-raise errors caught by the controller.
class Admin::IndexController; def rescue_action(e) raise e end; end

class Admin::IndexControllerTest < Test::Unit::TestCase
  def setup
    @controller = Admin::IndexController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index_access
    get :index
    assert_response 401 # Access denied
  end

  def test_clean_sessions_access
    get :clean_sessions
    assert_response 401 # Access denied
  end

end
