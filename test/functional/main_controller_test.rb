require File.dirname(__FILE__) + '/../test_helper'
require 'main_controller'

# Re-raise errors caught by the controller.
class MainController; def rescue_action(e) raise e end; end

class MainControllerTest < Test::Unit::TestCase
  def setup
    @controller = MainController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

end
