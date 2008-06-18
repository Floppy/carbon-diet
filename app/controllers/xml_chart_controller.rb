class XmlChartController < ApplicationController
  before_filter :get_current_user
  before_filter :set_xml_content_type
  before_filter :set_user, :except => [:electricity_supplier_pie, :pie_group]

private  

  def set_xml_content_type
    headers["Content-Type"] = "application/xml; charset=utf-8" 
  end

  def set_user
    unless params[:user].nil?
      if ((not @current_user.nil?) and (@current_user.id == params[:user].to_i))
        @user = @current_user
      else
        @user = User.find_by_id_and_public(params[:user], true)
      end
    else
      @user = @current_user
    end
    if @user.nil?
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      return
    end
  end

public

  def elec_supplier_pie
    # Get electricity supplier
    @supplier = ElectricitySupplier.find_by_id(params[:id])
    # Send data
    render :action => 'elec_supplier_pie.rxml', :layout => false
  end

  def line_all
    # Generate graph
    generate_line_graph(@user.all_emissions)
  end
  
  def line_all_settings
    @max = line_graph_max_value(params[:period].to_i)
    render :action => 'line_all_settings.rxml', :layout => false
  end

  def pie_group
    srand(69)
    # Store totals
    @totals = []
    @colours = []
    # Get group
    @group = Group.find_by_id(params[:id])
    total = 0.0
    @group.users.each { |u| total += u.annual_emissions if u.public }    
    # For each account, calculate emissions
    for user in @group.users
      # Create totals
      @totals << {:name => user.name, :data => { :total => user.annual_emissions, :percentage => user.annual_emissions/total} } if user.public
      # Create colours
      @colours << random_colour
    end
    # Send data
    render :action => 'pie.rxml', :layout => false
  end
 
  def pie_friends
    srand(42)
    # Store totals
    @totals = []
    @colours = []
    # Get friends
    friends = Array.new(@current_user.friends)
    friends << @current_user
    total = 0.0
    friends.each { |u| total += u.annual_emissions if u.public}    
    # For each account, calculate emissions
    for user in friends
      # Create totals
      @totals << {:name => user.name, :data => { :total => user.annual_emissions, :percentage => user.annual_emissions/total} } if user.public
      # Create colours
      @colours << random_colour
    end
    # Send data
    render :action => 'pie.rxml', :layout => false
  end
 
  def pie_all
    # Store totals
    @totals = []
    # For each account, calculate emissions
    for item in @user.all_emissions
      # Create totals
      @totals << {:name => item[:name], :data => item[:data].calculate_total_over_period(params[:period].to_i)}
    end
    # Create colours
    @colours = ["0000ff", "ff0000", "ff00ff", "00ff00", "00ffff"]
    # Send data
    render :action => 'pie.rxml', :layout => false
  end

  def notes_all
    notes = @user.all_notes
    @data = []
    day = params[:period].to_i.days.ago.to_date
    while (day <= Date.today)
      todays_note = notes.find { |x| x.date == day }
      str = todays_note ? todays_note.date.strftime("%b %d") + ": " + todays_note.note : nil
      @data << { :date => day, :note => str }
      day += 1
    end
    # Send data
    render :action => 'notes.rxml', :layout => false
  end

private

  def generate_line_graph(emissions)
    case params[:period].to_i
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
    total[:values] = Array.new(params[:period].to_i, nil)
    for dataset in emissions
      temp = dataset[:data].calculate_graph(params[:period].to_i, 1)
      running_avg = temp.smooth(avg_period)
      @data << { :name => dataset[:name],
                 :data => running_avg,
                 :dates => temp[:dates] }
      offset = 0
      if emissions.size > 1
        for datum in running_avg
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
    total[:notes] = Array.new(params[:period].to_i, nil)
    day = params[:period].to_i.days.ago.to_date + 1
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
    # Send data
    render :action => 'line.rxml', :layout => false
  end

  def line_graph_max_value(period)
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
    for dataset in @user.all_emissions
      if dataset[:name] != 'Flights'
        temp = dataset[:data].calculate_graph(period, 1)
        running_avg = temp.smooth(avg_period)
        offset = 0
        for datum in running_avg
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
    total[:values].max { |a,b| nilcomp(a,b) }
  end

  def random_colour
    format( "%06X", rand(16777216))
  end

  def nilcomp(a,b)
    return 0 if (a.nil? && b.nil?)
    return -1 if (a.nil?)
    return 1 if (b.nil?)
    return a <=> b
  end

end
