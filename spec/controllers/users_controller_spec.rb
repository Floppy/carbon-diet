require 'spec_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

describe UsersController do
  fixtures :users

  it "can view public profile if not logged in" do
    when_not_logged_in do
      get :show, :login => 'james'
      assert_response :success
    end
  end

  it "can view public profile if logged in" do
    when_logged_in(2) do
      get :show, :login => 'james'
      assert_response :success
    end
  end

  it "cannot view private profile if not logged in" do
    when_not_logged_in do
      get :show, :login => 'test002'
      assert_response :not_found
    end
  end

  it "can view private profile if logged in as right user" do
    when_logged_in(2) do
      get :show, :login => 'alice'
      assert_response :success
    end
  end

  it "can view private profile if logged in as wrong user" do
    when_logged_in(1) do
      get :show, :login => 'alice'
      assert_response :not_found
    end
  end

end