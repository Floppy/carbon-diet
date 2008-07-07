class Admin::IndexController < Admin::AdminController

  def index
    @pagename = "Administration"
    @num_users = User.count
    @num_elec_readings = ElectricityReading.count 
    @num_elec_accounts = ElectricityAccount.count 
    @num_gas_readings = GasReading.count 
    @num_gas_accounts = GasAccount.count 
    @num_vehicle_fuel_purchases = VehicleFuelPurchase.count 
    @num_vehicles = Vehicle.count 
    @num_flights = Flight.count 
    @num_sessions = CGI::Session::ActiveRecordStore::Session::count
    @num_old_sessions = CGI::Session::ActiveRecordStore::Session::count(:conditions => ["updated_at < ?", 1.month.ago.to_s(:db)])
    @data_file = url_for :action => "chart"
  end

  def clean_sessions
    CGI::Session::ActiveRecordStore::Session::destroy_all(["updated_at < ?", 1.month.ago.to_s(:db)])
    redirect_to :action => "index"
  end
  
  def clearcacheddata
    User.find(:all).each do |user| 
      user.annual_emission_total = nil
      user.save! unless user.login.empty?
    end
    redirect_to :action => "index" 
  end
  
  def chart
    @data = User.find(:all,
                      :select => "COUNT(*) AS count, date(`created_at`) as date",
                      :conditions => ["created_at > ?", 3.months.ago.to_date],
                      :order => "date",
                      :group => "date")
    render :action => 'chart.rxml', :layout => false
  end

end
