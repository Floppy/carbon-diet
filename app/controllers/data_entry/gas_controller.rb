class DataEntry::GasController < AuthenticatedController

  # Filters
  before_filter :check_gas_account
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
      @tip = "You can use meter readings from your old gas bills to fill in the last few years."
    end
    # Page name
    @pagename = "Readings for " + @account.name
    # Data
    @gas_reading_pages, @gas_readings = paginate :gas_readings, {:per_page => 20, :conditions => ["gas_account_id = ?", @account.id], :order => "taken_on DESC"}
  end

  def edit
    @gas_reading = params[:id] ? @account.gas_readings.find_by_id(params[:id]) : GasReading.new
    if request.post?
      @gas_reading.gas_account = @account
      @gas_reading.update_attributes(params[:gas_reading])
      if @gas_reading.save
        @current_user.update_stored_statistics!
        index
      end
    end
    # Set page name
    if params[:id]
      @pagename = "Editing gas reading"
    else
      @pagename = "Add gas reading"
    end
  end

  def mobile
    @gas_reading = GasReading.new
    if request.post?
      @gas_reading.gas_account = @account
      @gas_reading.update_attributes(params[:gas_reading])
      redirect_to_main_page if @gas_reading.save
      return
    end
    render :action => 'mobile', :layout => false
  end

  def destroy
    reading = @account.gas_readings.find_by_id(params[:id])
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

  def check_gas_account
    if @current_user
      @account = @current_user.gas_accounts.find_by_id(params[:account])
      if @account.nil?
        flash[:notice] = "Invalid account!"
        redirect_to_main_page
      end
    end
  end

end
