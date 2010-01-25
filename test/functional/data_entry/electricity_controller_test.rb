require File.dirname(__FILE__) + '/../../test_helper'
require 'electricity_readings_controller'

# Re-raise errors caught by the controller.
class ElectricityReadingsController; def rescue_action(e) raise e end; end

class ElectricityReadingsControllerTest < Test::Unit::TestCase
  fixtures :electricity_readings

  def setup
    @controller = ElectricityReadingsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    #get :index
    #assert_response :success
    #assert_template 'list'
  end

  def test_list
    #get :list

    #assert_response :success
    #assert_template 'list'

    #assert_not_nil assigns(:electricity_readings)
  end

  def test_show
    #get :show, :id => 1

    #assert_response :success
    #assert_template 'show'

    #assert_not_nil assigns(:electricity_reading)
    #assert assigns(:electricity_reading).valid?
  end

  def test_new
    #get :new

    #assert_response :success
    #assert_template 'new'

    #assert_not_nil assigns(:electricity_reading)
  end

  def test_create
    #num_electricity_readings = ElectricityReading.count

    #post :create, :electricity_reading => {}

    #assert_response :redirect
    #assert_redirected_to :action => 'list'

    #assert_equal num_electricity_readings + 1, ElectricityReading.count
  end

  def test_edit
    #get :edit, :id => 1

    #assert_response :success
    #assert_template 'edit'

    #assert_not_nil assigns(:electricity_reading)
    #assert assigns(:electricity_reading).valid?
  end

  def test_update
    #post :update, :id => 1
    #assert_response :redirect
    #assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    #assert_not_nil ElectricityReading.find(1)

    #post :destroy, :id => 1
    #assert_response :redirect
    #assert_redirected_to :action => 'list'

    #assert_raise(ActiveRecord::RecordNotFound) {
    #  ElectricityReading.find(1)
    #}
  end
end
