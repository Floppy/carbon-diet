class VehiclesController < AuthenticatedController
  def index
    redirect_to :controller => '/data_entry/index', :action => 'edit_accounts'
  end

  def edit
    @vehicle = params[:id] ? @current_user.vehicles.find_by_id(params[:id]) : Vehicle.new
    @vehicle_fuel_classes = @current_user.country.vehicle_fuel_classes.find( :all, :order => 'name')
    @vehicle_fuel_units = VehicleFuelUnit.find( :all, :order => 'name')
    @vehicle_distance_units = VehicleDistanceUnit.find( :all, :order => 'name')
    unless request.post? or params[:id]
      @vehicle.vehicle_distance_unit = @current_user.country.vehicle_distance_unit
      @vehicle.vehicle_fuel_unit = @current_user.country.vehicle_fuel_unit
    end
    if request.post?
      @vehicle.user = @current_user
      @vehicle.update_attributes(params[:vehicle])
      @current_user.update_stored_statistics!
      redirect_to :controller => '/data_entry/vehicle_fuel', :vehicle => @vehicle if @vehicle.save
    end
    # Set page name
    if params[:id]
      @pagename = "Editing " + @vehicle.name
    else
      @pagename = "Add vehicle"
    end
  end

  def destroy
    vehicle = @current_user.vehicles.find_by_id(params[:id])
    vehicle.destroy if not vehicle.nil?
    @current_user.update_stored_statistics!
    index
  end

end
