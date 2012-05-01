require 'spec_helper'
require 'reports_controller'

describe ReportsController do
  fixtures :users

  before do
    @controller = ReportsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def amline(user,period)
    get :recent_chart, :period => period, :user_id => User.find(user).login, :format => 'amline'
    assert_response :success
    assert_template 'reports/recent_chart.amline.builder'
    assigns["data"].each do |dataset|
      dataset[:data].size.should == period
      dataset[:notes].size.should == period if dataset[:notes]
      if dataset[:notes]
        for note in dataset[:notes] do
          note.nil?.should_not == true
          note[:date].nil?.should_not == true
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

  it "cannot view any html pages if not logged in" do
    when_not_logged_in do
      get :show, :user_id => User.find(1).login
      assert_response :redirect
      get :recent, :user_id => User.find(1).login
      assert_response :redirect
      get :ratio, :user_id => User.find(1).login
      assert_response :redirect
    end
  end

  it "cannot view any html pages if logged in as wrong person" do
    when_logged_in(2) do
      get :show, :user_id => User.find(1).login
      assert_response :unauthorized
      get :recent, :user_id => User.find(1).login
      assert_response :unauthorized
      get :ratio, :user_id => User.find(1).login
      assert_response :unauthorized
    end
  end

  it "can view html pages if logged in as right person" do
    when_logged_in(1) do
      get :show, :user_id => User.find(1).login
      assert_response :success
      get :recent, :user_id => User.find(1).login
      assert_response :success
      get :ratio, :user_id => User.find(1).login
      assert_response :success
    end
  end

  it "can view public charts if not logged in" do
    when_not_logged_in do
      amline(1,30)
      xmlpie(1,30)
    end
  end

  it "can view public charts if logged in" do
    when_logged_in(2) do
      amline(1,30)
      xmlpie(1,30)
    end
  end

  it "cannot view private charts if not logged in" do
    when_not_logged_in do
      get :recent_chart, :period => 30, :user_id => User.find(2).login, :format => 'amline'
      assert_response :missing
      get :recent_chart, :period => 30, :user_id => User.find(2).login, :format => 'amline_settings'
      assert_response :missing
      get :ratio_chart, :period => 30, :user_id => User.find(2).login, :format => 'xmlchart'
      assert_response :missing
    end
  end

  it "cannot view private charts if not logged in as right user" do
    when_logged_in(1) do
      get :recent_chart, :period => 30, :user_id => User.find(2).login, :format => 'amline'
      assert_response :missing
      get :recent_chart, :period => 30, :user_id => User.find(2).login, :format => 'amline_settings'
      assert_response :missing
      get :ratio_chart, :period => 30, :user_id => User.find(2).login, :format => 'xmlchart'
      assert_response :missing
    end
  end

  it "can view private charts if logged in as right user" do
    when_logged_in(2) do
      amline(2,30)
      xmlpie(2,30)
    end
  end

  it "charts long" do
    amline(1,1460)
    xmlpie(1,1460)
  end

  it "charts no data" do
    amline(9,30)
    xmlpie(9,30)
  end

  it "line chart no notes" do
    amline(3,30)
  end

end
