class DataEntry::ElectricityController < AuthenticatedController

  # Filters
  before_filter :check_elec_account
  skip_before_filter :check_logged_in, :only => [:currentcost]

  def index
    redirect_to :action => 'list'
  end

  def list
    # Tip
    case rand(2)
    when 0 
      @tip = "Enter your meter readings regularly to get the most accurate results."
    else
      @tip = "You can use meter readings from your old electricity bills to fill in the last few years."
    end
    # Page name
    @pagename = "Readings for " + @account.name
    # Data
    @electricity_reading_pages, @electricity_readings = paginate :electricity_readings, {:per_page => 20, :conditions => ["electricity_account_id = ?", @account.id], :order => "taken_on DESC"}
  end

  def edit
    @electricity_reading = params[:id] ? @account.electricity_readings.find_by_id(params[:id]) : ElectricityReading.new
    if request.post?
      @electricity_reading.electricity_account = @account
      @electricity_reading.update_attributes(params[:electricity_reading])
      if @electricity_reading.save
        @current_user.update_stored_statistics!
        mobile? ? redirect_to_main_page : index
        return
      end
    end
    # Set page name
    if params[:id]
      @pagename = "Editing electricity reading"
    else
      @pagename = "Add electricity reading"
    end
    # Respond
    respond_to do |format|
      format.html
      format.iphone { render :layout => false }
      format.wml
    end
  end

  def destroy
    reading = @account.electricity_readings.find_by_id(params[:id])
    reading.destroy if not reading.nil?
    @current_user.update_stored_statistics!
    index
  end

  def export
    # Render
    headers["Content-Type"] = "application/xml; charset=utf-8" 
    render :action => "export.rxml", :layout => false
  rescue
    render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
  end

  def currentcost
    # Receives data from my currentcost daemon
    authenticate_with_http_basic do |username, password|
      # Authenticate
      result = User.authenticate(username, password)
      @current_user = User.find_by_id(result)
      render(:nothing => true, :status => 401) and return if @current_user.nil?
      # Get the account
      @account = @current_user.electricity_accounts.find_by_id(params[:account])
      render(:nothing => true, :status => 401) and return if @account.nil?
      # Load data from XML
      doc = REXML::Document.new(request.raw_post)
      # For each item in the history
      REXML::XPath.each(doc, '/data/entry') do |entry|
        date = Date.parse(entry.elements['date'].text)
        value = entry.elements['value'].text
        # Is there already a reading for today?
        break if @account.electricity_readings.find(:first, :conditions => {:taken_on => date})
        # If not, find a reading for yesterday and add today's figure onto it
        previous = @account.electricity_readings.find(:first, :conditions => {:taken_on => date - 1})
        if previous
          kwh = previous.kWh_day + value.to_i
          reading = kwh / @account.electricity_unit.amount_in_kWh
          @account.electricity_readings.create(:automatic => true, 
                                               :taken_on => date,
                                               :reading_day => reading,
                                               :reading_night => previous.reading_night)
        end
      end
      # Render result - just 201 Created
      render(:nothing => true, :status => 201)
    end
  end

private

  def check_elec_account
    if @current_user
      @account = @current_user.electricity_accounts.find_by_id(params[:account])
      if @account.nil?
        flash[:notice] = "Invalid account!"
        redirect_to_main_page
      end
    end
  end

end
