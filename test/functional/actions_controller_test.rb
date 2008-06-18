require File.dirname(__FILE__) + '/../test_helper'
require 'actions_controller'

# Re-raise errors caught by the controller.
class ActionsController; def rescue_action(e) raise e end; end

class ActionsControllerTest < Test::Unit::TestCase
  def setup
    @controller = ActionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

end
