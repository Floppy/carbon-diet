require File.dirname(__FILE__) + '/../test_helper'
require 'reports_controller'

class ReportsControllerTest < ActionController::TestCase
  fixtures :users

  def setup
    @controller = ReportsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def amline(user,period)
    get :recent_chart, :period => period, :user_id => User.find(user).login, :format => 'amline'
    assert_response :success
    assert_template 'reports/recent_chart.amline.builder'
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
    get :recent_chart, :period => period, :user_id => User.find(user).login, :format => 'amline_settings'
    assert_response :success
    assert_template 'reports/recent_chart.amline_settings.builder'
  end

  def xmlpie(user, period)
    get :ratio_chart, :period => period, :user_id => User.find(user).login, :format => 'xmlchart'
    assert_response :success
    assert_template 'shared/pie.xmlchart.builder'
  end

  def test_cannot_view_any_html_pages_if_not_logged_in
    when_not_logged_in do
      get :show, :user_id => User.find(1).login
      assert_response :redirect
      get :recent, :user_id => User.find(1).login
      assert_response :redirect
      get :ratio, :user_id => User.find(1).login
      assert_response :redirect
    end
  end

  def test_cannot_view_any_html_pages_if_logged_in_as_wrong_person
    when_logged_in(2) do
      get :show, :user_id => User.find(1).login
      assert_response :unauthorized
      get :recent, :user_id => User.find(1).login
      assert_response :unauthorized
      get :ratio, :user_id => User.find(1).login
      assert_response :unauthorized
    end
  end

  def test_can_view_html_pages_if_logged_in_as_right_person
    when_logged_in(1) do
      get :show, :user_id => User.find(1).login
      assert_response :success
      get :recent, :user_id => User.find(1).login
      assert_response :success
      get :ratio, :user_id => User.find(1).login
      assert_response :success
    end
  end

  def test_can_view_public_charts_if_not_logged_in
    when_not_logged_in do
      amline(1,30)
      xmlpie(1,30)
    end
  end

  def test_can_view_public_charts_if_logged_in
    when_logged_in(2) do
      amline(1,30)
      xmlpie(1,30)
    end
  end

  def test_cannot_view_private_charts_if_not_logged_in
    when_not_logged_in do
      get :recent_chart, :period => 30, :user_id => User.find(2).login, :format => 'amline'
      assert_response :missing
      get :recent_chart, :period => 30, :user_id => User.find(2).login, :format => 'amline_settings'
      assert_response :missing
      get :ratio_chart, :period => 30, :user_id => User.find(2).login, :format => 'xmlchart'
      assert_response :missing
    end
  end

  def test_cannot_view_private_charts_if_not_logged_in_as_right_user
    when_logged_in(1) do
      get :recent_chart, :period => 30, :user_id => User.find(2).login, :format => 'amline'
      assert_response :missing
      get :recent_chart, :period => 30, :user_id => User.find(2).login, :format => 'amline_settings'
      assert_response :missing
      get :ratio_chart, :period => 30, :user_id => User.find(2).login, :format => 'xmlchart'
      assert_response :missing
    end
  end

  def test_can_view_private_charts_if_logged_in_as_right_user
    when_logged_in(2) do
      amline(2,30)
      xmlpie(2,30)
    end
  end

  def test_charts_long
    amline(1,1460)
    xmlpie(1,1460)
  end

  def test_charts_no_data
    amline(9,30)
    xmlpie(9,30)
  end

  def test_line_chart_no_notes
    amline(3,30)
  end

end
