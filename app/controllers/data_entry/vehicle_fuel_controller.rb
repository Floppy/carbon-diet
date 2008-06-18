class DataEntry::VehicleFuelController < AuthenticatedController

  # Filters
  prepend_before_filter :enable_mobile_mode, :only => [ :mobile ]
  before_filter :check_vehicle

  def index
    redirect_to :action => 'list'
  end

  def list
    # Tip
    case rand(2)
    when 0 
      @tip = "Every time you buy fuel, add it here to track how much you've used."
    else 
      @tip = "If you always fill up at the same point on your fuel gauge, the results will be more accurate."
    end
    # Page name
    @pagename = "Fuel purchases for " + @vehicle.name
    # Data
    @vehicle_fuel_purchase_pages, @vehicle_fuel_purchases = paginate :vehicle_fuel_purchases, {:per_page => 20, :conditions => ["vehicle_id = ?", @vehicle.id], :order => "purchased_on DESC"}
  end

  def edit
    @vehicle_fuel_purchase = params[:id] ? @vehicle.vehicle_fuel_purchases.find_by_id(params[:id]) : VehicleFuelPurchase.new
    @vehicle_fuel_types = @vehicle.vehicle_fuel_class.vehicle_fuel_types.find( :all, :order => 'name')
    unless params[:id]
      @vehicle_fuel_purchase.vehicle_fuel_type = VehicleFuelType.default(@vehicle.vehicle_fuel_class)
    end
    if request.post?
      @vehicle_fuel_purchase.vehicle = @vehicle
      @vehicle_fuel_purchase.update_attributes(params[:vehicle_fuel_purchase])
      if @vehicle_fuel_purchase.save
        @current_user.update_stored_statistics!
        index
      end
    end
    # Set page name
    if params[:id]
      @pagename = "Editing fuel purchase"
    else
      @pagename = "Add fuel purchase"
    end
  end

  def mobile
    @vehicle_fuel_purchase = VehicleFuelPurchase.new
    @vehicle_fuel_types = @vehicle.vehicle_fuel_class.vehicle_fuel_types
    unless params[:id]
      @vehicle_fuel_purchase.vehicle_fuel_type = VehicleFuelType.default(@vehicle.vehicle_fuel_class)
    end
    if request.post?
      @vehicle_fuel_purchase.vehicle = @vehicle
      @vehicle_fuel_purchase.update_attributes(params[:vehicle_fuel_purchase])
      redirect_to_main_page if @vehicle_fuel_purchase.save
      return
    end
    render :action => 'mobile', :layout => false
  end

  def destroy
    purchase = @vehicle.vehicle_fuel_purchases.find_by_id(params[:id])
    purchase.destroy unless purchase.nil?
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

  def check_vehicle
    if @current_user
      @vehicle = @current_user.vehicles.find_by_id(params[:vehicle])
      if @vehicle.nil?
        flash[:notice] = "Invalid vehicle!"
        redirect_to_main_page
      end
    end
  end

end
