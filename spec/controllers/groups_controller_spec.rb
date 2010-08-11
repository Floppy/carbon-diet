require File.dirname(__FILE__) + '/../spec_helper'
require 'groups_controller'

# Re-raise errors caught by the controller.
class GroupsController; def rescue_action(e) raise e end; end

describe GroupsController do

  fixtures :groups

  before do
    @controller = GroupsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

end
