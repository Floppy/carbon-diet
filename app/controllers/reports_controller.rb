class ReportsController < BelongsToUser

  include GraphFunctions

  def show
    respond_to do |format|
      format.html {
        @total = 0.0
        @user.all_emissions.each do |item|
          # Calculate total
          temp = item[:data].calculate_total
          # Add up data
          @total += temp[:total]
        end
        # Calculate daily and yearly amounts based on total
        days = Date::today - @user.date_of_first_data
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
        days = Date::today - @user.date_of_first_data
        days = 365 if days > 365
        @totals = @user.calculate_totals(days)
        render_iphone
      }
    end
  end

  def ratio
    respond_to do |format|
      format.html {
        # Calculate totals
        @totals = @user.calculate_totals(365)
        @data_file = ratio_user_report_path(@user, :format => :xmlchart, :period => 365)
        @pagename = "CO2 sources (over the last year)"
      }
      format.xmlchart {
        # Store totals
        @totals = []
        # For each account, calculate emissions
        @user.all_emissions.each do |item|
          # Create totals
          @totals << {:name => item[:name], :data => item[:data].calculate_total_over_period(params[:period].to_i)}
        end
        # Create colours
        @colours = ["0000ff", "ff0000", "ff00ff", "00ff00", "00ffff"]
        # Send data
        render :file => 'shared/pie', :layout => false
      }
    end
  end

  def recent
    respond_to do |format|
      format.html {
        @start_date = @user.date_of_first_data
        period = Date.today - @start_date
        # Calculate totals
        @totals = @user.calculate_totals(period)
        @data_file = recent_user_report_path(@user, :format => :amline, :period => period)
        # Set variables for data access
        @line_settings_url = recent_user_report_path(@user, :format => :amline_settings, :period => period)
        @show_flight_controls = @user.flights.count > 0 ? true : false;
        @pagename = "Daily trends"
      }
      format.amline {
        amline(params[:period].to_i)
        render :layout => false
      }
      format.amline_settings {
        amline_settings(params[:period].to_i)
        render :layout => false
      }
    end
  end

  protected

  def amline(period)
    # Generate graph
    emissions = @user.all_emissions
    case period
    when 0..90
      avg_period = 3
    when 91..365
      avg_period = 7
    else
      avg_period = 14
    end
    # Create graph data
    @data = []
    total = GraphData.new
    total[:values] = Array.new(period, nil)
    emissions.each do |dataset|
      temp = dataset[:data].calculate_graph(period, 1)
      running_avg = temp.smooth(avg_period)
      @data << { :name => dataset[:name],
                 :data => running_avg,
                 :dates => temp[:dates] }
      offset = 0
      if emissions.size > 1
        running_avg.each do |datum|
          unless datum.nil?
            if total[:values][offset].nil?
              total[:values][offset] = 0
            end
              total[:values][offset] += datum
          end
          offset += 1
        end
      end
    end
    # Load notes
    notes = @user.all_notes
    total[:notes] = Array.new(period, nil)
    day = period.days.ago.to_date + 1
    i = 0
    while (day <= Date.today)
      todays_note = notes.find { |x| x.date == day }
      str = todays_note ? todays_note.note : nil
      total[:notes][i] = { :date => day, :note => str }
      i += 1
      day += 1
    end
    # Add total line
    if emissions.size > 1
      @data << { :name => 'Total',
                 :data => total[:values],
                 :notes=> total[:notes]}
    end
    # View settings
    colours = ["0000ff", "ff0000", "ff00ff", "00ff00", "00ffff", "ffff00",
                "00007f", "7f0000", "7f007f", "007f00", "007f7f", "7f7f00"]
    colours[emissions.size] = "d0d0d0"
    colour = 0
    @data.each do |data|
      data[:colour] = colours[colour]
      colour += 1
    end
    # Render
  end

  def amline_settings(period)
    case period
    when 0..90
      avg_period = 3
    when 91..365
      avg_period = 7
    else
      avg_period = 14
    end
    total = GraphData.new
    total[:values] = Array.new(period, nil)
    # Add all emissions together that are not flights
    @user.all_emissions.each do |dataset|
      if dataset[:name] != 'Flights'
        temp = dataset[:data].calculate_graph(period, 1)
        running_avg = temp.smooth(avg_period)
        offset = 0
        running_avg.each do |datum|
          unless datum.nil?
            if total[:values][offset].nil?
              total[:values][offset] = 0
            end
            total[:values][offset] += datum
          end
          offset += 1
        end
      end
    end
    @max = total[:values].max { |a,b| nilcomp(a,b) }
  end

end
