require File.dirname(__FILE__) + '/../test_helper'
require 'friends_controller'

# Re-raise errors caught by the controller.
class FriendsController; def rescue_action(e) raise e end; end

class FriendsControllerTest < Test::Unit::TestCase
  def setup
    @controller = FriendsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_truth
    assert true
  end
end
