class VehiclesController < BelongsToUser
  before_filter :get_vehicle, :except => [:index, :new, :create]

  def index
    redirect_to :controller => '/data_entry/index', :action => 'edit_accounts'
  end

  def new
    @vehicle = Vehicle.new
    # Set default values
    @vehicle.vehicle_distance_unit = @current_user.country.vehicle_distance_unit
    @vehicle.vehicle_fuel_unit = @current_user.country.vehicle_fuel_unit
    # Get options for select
    get_select_options
  end

  def create
    @vehicle = @user.vehicles.create(params[:vehicle])
    if @vehicle.save
      @user.update_stored_statistics!
      redirect_to :controller => '/data_entry/vehicle_fuel', :vehicle => @vehicle
    else
      get_select_options
      render :action => 'new'
    end
  end

  def edit
    get_select_options
  end

  def update
    @vehicle.update_attributes!(params[:vehicle])
    if @vehicle.save
      @user.update_stored_statistics!
      redirect_to :controller => '/data_entry/vehicle_fuel', :vehicle => @vehicle
    else
      get_select_options
      render :action => 'edit'
    end
  end

  def destroy
    @vehicle.destroy
    @user.update_stored_statistics!
    redirect_to :controller => '/data_entry/index', :action => 'edit_accounts'
  end

protected

  def get_select_options
    @vehicle_fuel_classes = @current_user.country.vehicle_fuel_classes.find( :all, :order => 'name')
    @vehicle_fuel_units = VehicleFuelUnit.find( :all, :order => 'name')
    @vehicle_distance_units = VehicleDistanceUnit.find( :all, :order => 'name')
  end

  def get_vehicle
    @vehicle = @current_user.vehicles.find(params[:id])
  end

end
