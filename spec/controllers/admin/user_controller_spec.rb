require File.dirname(__FILE__) + '/../../spec_helper'
require 'admin/user_controller'
require 'admin/admin_controller'

# Re-raise errors caught by the controller.
class Admin::UserController; def rescue_action(e) raise e end; end

describe Admin::UserController do
  fixtures :users

  before do
    @controller = Admin::UserController.new
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

  it "resetpw access" do
    get :resetpw, :id => 1
    assert_response 401 # Access denied
  end

  it "chart access" do
    get :chart
    assert_response 401 # Access denied
  end

  it "clearcachedata access" do
    get :clearcachedata
    assert_response 401 # Access denied
  end

end
