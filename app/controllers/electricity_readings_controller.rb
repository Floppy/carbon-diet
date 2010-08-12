class ElectricityReadingsController < BelongsToUser
  # Filters
  before_filter :get_elec_account
  before_filter :get_elec_reading, :except => [:new, :create, :index]

  # Don't require auth for currentcost readings - we have basic auth built into the action
  skip_before_filter :check_logged_in, :only => [:currentcost]

  def index
    respond_to do |format|
      format.html {
        @tip = tips.rand
        @electricity_readings = @account.electricity_readings.paginate :page => params[:page], :order => 'taken_on DESC'
      }
      format.xml {
        @electricity_readings = @account.electricity_readings.find(:all, :order => "taken_on DESC")
      }
    end
  end

  def new
    @reading = ElectricityReading.new
    respond_to do |format|
      format.html
      format.iphone { render_iphone }
      format.wml
    end
  end

  def create
    @reading = @account.electricity_readings.create(params[:electricity_reading])
    if @reading.save
      mobile? ? redirect_to_main_page : redirect_to(user_electricity_account_electricity_readings_path(@user, @account))
    else
      respond_to do |format|
        format.html { render :action => 'new' }
        format.iphone { render_iphone :action => 'new', :layout => 'application' }
        format.wml { render :action => 'new' }
      end
    end
  end

  def edit
  end

  def update
    @reading.update_attributes(params[:electricity_reading])
    if @reading.save
      mobile? ? redirect_to_main_page : redirect_to(user_electricity_account_electricity_readings_path(@user, @account))
    else
      render :action => 'edit'
    end
  end

  def destroy
    @reading.destroy
    redirect_to(user_electricity_account_electricity_readings_path(@user, @account))
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

  def get_elec_account
    @account = @user.electricity_accounts.find(params[:electricity_account_id])
  end

  def get_elec_reading
    @reading = @account.electricity_readings.find(params[:id])
  end

  def tips
    [
      "Enter your meter readings regularly to get the most accurate results.",
      "You can use meter readings from your old electricity bills to fill in the last few years."
    ]
  end

end
