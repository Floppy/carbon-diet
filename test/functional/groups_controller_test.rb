require File.dirname(__FILE__) + '/../test_helper'
require 'groups_controller'

# Re-raise errors caught by the controller.
class GroupsController; def rescue_action(e) raise e end; end

class GroupsControllerTest < ActionController::TestCase

  fixtures :groups

  def setup
    @controller = GroupsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def when_logged_in
    @request.session[:user_id] = 1
    yield
  end
  
  def when_not_logged_in
    @request.session[:user_id] = nil
    yield
  end

  def test_invite
    @group = Group.find(2)
    when_logged_in do
      get :invite, :id => @group.id
      assert_response :success
      assert_template 'invite'
    end
    when_not_logged_in do
      get :invite, :id => @group.id
      assert_response :redirect 
      assert_redirected_to '/'
    end
  end

  def test_send_invitations
    when_logged_in do
      post :send_invitations, :id => 2
      assert_response :redirect
      assert_redirected_to '/groups/view/2'
    end
    when_not_logged_in do
      post :send_invitations, :id => 2
      assert_response :redirect
      assert_redirected_to '/'
    end
  end
end
