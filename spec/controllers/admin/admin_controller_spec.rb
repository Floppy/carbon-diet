require File.dirname(__FILE__) + '/../../spec_helper'
require 'admin/admin_controller'

# Re-raise errors caught by the controller.
class Admin::AdminController; def rescue_action(e) raise e end; end

describe Admin::AdminController do
  before do
    @controller = Admin::AdminController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  it "index access" do
    get :index
    assert_response 401 # Access denied
  end

  it "clean sessions access" do
    get :clean_sessions
    assert_response 401 # Access denied
  end

end
