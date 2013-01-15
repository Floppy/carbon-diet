require 'spec_helper'
require 'invitations_controller'

# Re-raise errors caught by the controller.
class InvitationsController; def rescue_action(e) raise e end; end

describe InvitationsController do

  fixtures :groups

  before do
    @controller = InvitationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @group = Group.find(2)
  end

  it "redirect when not logged in" do
    when_not_logged_in do
      get :new, :group_id => @group.name
      assert_response :redirect
      assert_redirected_to '/'
    end
  end
  
  it "invite when logged in" do
    when_logged_in(1) do
      get :new, :group_id => @group.name
      assert_response :success
      assert_template 'new'
    end
  end

  context "send invitations" do
    
    it "redirect when not logged in" do
      when_not_logged_in do
        post :create, :group_id => @group.name, :invite => {'james' => '1'}
        assert_response :redirect
        assert_redirected_to '/'
      end
    end
    
    it "send when logged in" do
      when_logged_in(1) do
        post :create, :group_id => @group.name, :invite => {'james' => '1'}
        assert_response :redirect
        assert_redirected_to @group
      end
    end
  end
end
