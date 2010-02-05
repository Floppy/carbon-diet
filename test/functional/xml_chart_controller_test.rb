require File.dirname(__FILE__) + '/../test_helper'
require 'xml_chart_controller'

# Re-raise errors caught by the controller.
class XmlChartController; def rescue_action(e) raise e end; end

class XmlChartControllerTest < ActionController::TestCase
  fixtures :users

  def setup
    @controller = XmlChartController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  def line_all(user,period)
    get :line_all, :period => period, :user => user
    assert_response :success
    assert_template 'line.rxml'
    assigns["data"].each do |dataset|
      assert dataset[:data].size == period
      assert dataset[:notes].size == period if dataset[:notes]
      if dataset[:notes]
        for note in dataset[:notes] do
          assert !note.nil? 
          assert !note[:date].nil?
        end
      end
    end    
  end

  def test_line_all
    line_all(1,30)
  end

  def test_line_all_long
    line_all(1,1460)
  end

  def test_line_all_private
    get :line_all, :period => 30, :user => 2
    assert_response :missing
  end
  
  def test_line_all_no_data
    line_all(9,30)
  end

  def test_line_all_no_notes
    line_all(3,30)
  end

  def line_all_settings(user, period)
    get :line_all_settings, :period => period, :user => user
    assert_response :success
    assert_template 'line_all_settings.rxml'
  end

  def test_line_all_settings
    line_all_settings(1,30)
  end

  def test_line_all_settings_long
    line_all_settings(1,1460)
  end

  def test_line_all_settings_private
    get :line_all_settings, :period => 30, :user => 2
    assert_response :missing
  end

  def test_line_all_settings_no_data
    line_all_settings(9,30)
  end

end
