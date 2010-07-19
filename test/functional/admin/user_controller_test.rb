require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/user_controller'
require 'admin/admin_controller'

# Re-raise errors caught by the controller.
class Admin::UserController; def rescue_action(e) raise e end; end

class Admin::UserControllerTest < ActionController::TestCase
  fixtures :users

  def setup
    @controller = Admin::UserController.new
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

  def test_resetpw_access
    get :resetpw, :id => 1
    assert_response 401 # Access denied
  end

  def test_chart_access
    get :chart
    assert_response 401 # Access denied
  end

  def test_clearcachedata_access
    get :clearcachedata
    assert_response 401 # Access denied
  end

end
