class UsersController < ApplicationController
  before_filter :get_current_user

  def legacy_profile_redirect
    if @current_user
      redirect_to @current_user, :status => :moved_permanently
    else
      redirect_to '/', :status => :moved_permanently
    end
  end

  def show
    if not @current_user.nil? and (params[:login] == @current_user.login or params[:login].nil?)
      @profile = @current_user
    else
      @profile = User.find_by_login_and_public(params[:login], true)
    end
    if @profile.nil?
      if params[:login].present?
        render_http_code(404)
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
      }
      format.iphone { render_iphone :layout => 'application' }
      format.wml
    end
  end

private

  def report_period
    days = Date::today - @profile.date_of_first_data
    return days < 365 ? days : 365
  end
  
end