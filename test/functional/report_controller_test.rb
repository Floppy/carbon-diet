require File.dirname(__FILE__) + '/../test_helper'
require 'report_controller'

# Re-raise errors caught by the controller.
class ReportController; def rescue_action(e) raise e end; end

class ReportControllerTest < Test::Unit::TestCase
  def setup
    @controller = ReportController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

end
