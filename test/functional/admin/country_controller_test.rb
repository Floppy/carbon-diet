require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/country_controller'

# Re-raise errors caught by the controller.
class Admin::CountryController; def rescue_action(e) raise e end; end

class Admin::CountryControllerTest < ActionController::TestCase
  fixtures :countries

  def setup
    @controller = Admin::CountryController.new
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

  def test_set_current_access
    get :set_current, :id => 1
    assert_response 401 # Access denied
  end

end
