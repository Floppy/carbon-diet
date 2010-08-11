require File.dirname(__FILE__) + '/../../spec_helper'
require 'admin/electricity_suppliers_controller'

# Re-raise errors caught by the controller.
class Admin::ElectricitySuppliersController; def rescue_action(e) raise e end; end

describe Admin::ElectricitySuppliersController do
  fixtures :electricity_suppliers

  before do
    @controller = Admin::ElectricitySuppliersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  it "index access" do
    get :index
    assert_response 401 # Access denied
  end

  it "list access" do
    get :list
    assert_response 401 # Access denied
  end

  it "edit access" do
    get :edit, :id => 1
    assert_response 401 # Access denied
  end

  it "destroy access" do
    get :destroy, :id => 1
    assert_response 401 # Access denied
  end

end