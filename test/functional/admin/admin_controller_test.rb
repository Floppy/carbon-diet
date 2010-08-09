require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/admin_controller'

# Re-raise errors caught by the controller.
class Admin::AdminController; def rescue_action(e) raise e end; end

class Admin::AdminControllerTest < ActionController::TestCase
  def setup
    @controller = Admin::AdminController.new
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
