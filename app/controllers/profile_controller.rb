class ProfileController < ApplicationController
  before_filter :get_current_user

  def index
    if not @current_user.nil? and (params[:login] == @current_user.login or params[:login].nil?)
      @profile = @current_user
    else
      @profile = User.find_by_login_and_public(params[:login], true)
    end
    if @profile.nil?
      if params[:login].present?
        flash[:notice] = "Profile not found!"
        redirect_to :controller => 'search'
      else
        redirect_to '/'
      end
      return
    end
    # Respond
    respond_to do |format|
      format.html {
        # Get emissions data
        @period = report_period
        @pie_url = ratio_chart_user_report_path(@profile, :format => :xmlchart, :period => @period)
        @line_url = recent_chart_user_report_path(@profile, :format => :amline, :period => @period)
        @line_settings_url = recent_chart_user_report_path(@profile, :format => :amline_settings, :period => @period)
        @show_flight_controls = @profile.flights.count > 0 ? true : false;
        @totals = @profile.calculate_totals(@period)
        # Get comments
        @comments = @profile.comments.find(:all, :limit => 5)
        # Get actions
        @actions = get_actions(3) if @profile == @current_user
      }
      format.iphone { render_iphone :layout => 'application' }
      format.wml
    end
  end

  def feed
    @user = User.find_by_guid(params[:id])
    @comments = @user.comments.find(:all, :order => "created_at DESC", :limit => 10)
    # Send data
    headers["Content-Type"] = "application/atom+xml"
    render :action => 'atom.rxml', :layout => false
  end

private

  def report_period
    days = Date::today - @profile.date_of_first_data
    return days < 365 ? days : 365
  end
  
end
