class GasReadingsController < BelongsToUser
  # Filters
  before_filter :get_gas_account
  before_filter :get_gas_reading, :except => [:new, :create, :index]

  def index
    respond_to do |format|
      format.html {
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
        @gas_readings = @account.gas_readings.paginate :page => params[:page], :order => "taken_on DESC"
      }
      format.xml {
        @gas_readings = @account.gas_readings.find(:all, :order => "taken_on DESC")
      }
    end
  end

  def new
    @reading = GasReading.new
    respond_to do |format|
      format.html
      format.iphone { render_iphone }
      format.wml
    end
  end

  def create
    @reading = @account.gas_readings.create(params[:gas_reading])
    if @reading.save
      mobile? ? redirect_to_main_page : redirect_to(user_gas_account_gas_readings_path(@user, @account))
    else
      respond_to do |format|
        format.html { render :action => 'new' }
        format.iphone { render_iphone :action => 'new' }
        format.wml { render :action => 'new' }
      end
    end
  end

  def edit
  end

  def update
    @reading.update_attributes(params[:gas_reading])
    if @reading.save
      mobile? ? redirect_to_main_page : redirect_to(user_gas_account_gas_readings_path(@user, @account))
    else
      render :action => 'edit'
    end
  end

  def destroy
    @reading.destroy
    redirect_to(user_gas_account_gas_readings_path(@user, @account))
  end

private

  def get_gas_account
    @account = @user.gas_accounts.find(params[:gas_account_id])
  end

  def get_gas_reading
    @reading = @account.gas_readings.find(params[:id])
  end

end