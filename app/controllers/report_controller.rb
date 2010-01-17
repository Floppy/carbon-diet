class ReportController < AuthenticatedController  

  def index
    respond_to do |format|
      format.html {
        @total = 0.0
        for item in @current_user.all_emissions
          # Calculate total
          temp = item[:data].calculate_total
          # Add up data
          @total += temp[:total]
        end
        # Calculate daily and yearly amounts based on total
        days = Date::today - @current_user.date_of_first_data
        @perday = @total / days
        @perannum = @perday * 365
        # Calculate litres per day... using 540L per kg
        @litres_per_day = @perday * 540
        # Calculate balloons per day... using a 2 litre balloon
        @balloons = @litres_per_day / 2
        @seconds_per_balloon = 86400 / @balloons
        # Compared the the amount you breathe out... based on 432L of CO2 per day breathed out
        @times_breathed_out = @litres_per_day / 432
        # Set page name
        @pagename = "View analysis"
      }
      format.iphone {
        days = Date::today - @current_user.date_of_first_data
        days = 365 if days > 365
        @totals = @current_user.calculate_totals(days)
        render :layout => false
      }
    end
  end

  def ratio
    # Calculate totals
    @totals = @current_user.calculate_totals(365)
    @data_file = url_for(:controller => "xml_chart", 
                         :action => "pie_all",
                         :period => 365)
    @pagename = "CO2 sources (over the last year)"
  end

  def recent
    @start_date = @current_user.date_of_first_data
    period = Date.today - @start_date
    # Calculate totals
    @totals = @current_user.calculate_totals(period)
    @data_file = url_for(:controller => "xml_chart", :action => "line_all", :period => period)
    # Set variables for data access
    @line_settings_url = url_for(:controller => "xml_chart", :action => "line_all_settings", :period => period, :user => @current_user.id)
    @show_flight_controls = @current_user.flights.count > 0 ? true : false;
    @pagename = "Daily trends"
  end

end
