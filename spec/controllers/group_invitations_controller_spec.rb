require File.dirname(__FILE__) + '/../spec_helper'
require 'group_invitations_controller'

# Re-raise errors caught by the controller.
class GroupInvitationsController; def rescue_action(e) raise e end; end

describe GroupInvitationsController do

  fixtures :groups

  before do
    @controller = GroupInvitationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @group = Group.find(2)
  end

  it "invite" do
    when_not_logged_in do
      get :new, :group_id => @group.name
      assert_response :redirect
      assert_redirected_to '/'
    end
    when_logged_in do
      get :new, :group_id => @group.name
      assert_response :success
      assert_template 'new'
    end
  end

  it "send invitations" do
    when_not_logged_in do
      post :create, :group_id => @group.name, :invite => {'james' => '1'}
      assert_response :redirect
      assert_redirected_to '/'
    end
    when_logged_in do
      post :create, :group_id => @group.name, :invite => {'james' => '1'}
      assert_response :redirect
      assert_redirected_to @group
    end
  end
end
