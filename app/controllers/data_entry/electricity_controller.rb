class DataEntry::ElectricityController < AuthenticatedController

  # Filters
  before_filter :check_elec_account
  prepend_before_filter :enable_mobile_mode, :only => [ :mobile ]

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
        index
      end
    end
    # Set page name
    if params[:id]
      @pagename = "Editing electricity reading"
    else
      @pagename = "Add electricity reading"
    end
  end

  def mobile
    @electricity_reading = ElectricityReading.new
    if request.post?
      @electricity_reading.electricity_account = @account
      @electricity_reading.update_attributes(params[:electricity_reading])
      redirect_to_main_page if @electricity_reading.save
      return
    end
    render :action => 'mobile', :layout => false
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
