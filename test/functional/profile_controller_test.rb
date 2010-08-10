require File.dirname(__FILE__) + '/../test_helper'
require 'profile_controller'

# Re-raise errors caught by the controller.
class ProfileController; def rescue_action(e) raise e end; end

class ProfileControllerTest < ActionController::TestCase
  fixtures :users

  def test_can_view_public_profile_if_not_logged_in
    when_not_logged_in do
      get :index, :login => 'james'
      assert_response :success
    end
  end

  def test_can_view_public_profile_if_logged_in
    when_logged_in(2) do
      get :index, :login => 'james'
      assert_response :success
    end
  end

  def test_cannot_view_private_profile_if_not_logged_in
    when_not_logged_in do
      get :index, :login => 'test002'
      assert_response :redirect
      assert_redirected_to '/search'
      assert flash[:notice] == 'Profile not found!'
    end
  end

  def test_can_view_private_profile_if_logged_in_as_right_user
    when_logged_in(2) do
      get :index, :login => 'test002'
      assert_response :success
    end
  end

  def test_can_view_private_profile_if_logged_in_as_wrong_user
    when_logged_in(1) do
      get :index, :login => 'test002'
      assert_response :redirect
      assert_redirected_to '/search'
      assert flash[:notice] == 'Profile not found!'
    end
  end

end