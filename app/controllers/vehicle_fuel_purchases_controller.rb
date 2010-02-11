class VehicleFuelPurchasesController < BelongsToUser
  # Filters
  before_filter :get_vehicle
  before_filter :get_purchase, :except => [:new, :create, :index]
  before_filter :get_select_options, :except => [:index, :destroy]

  def index
    respond_to do |format|
      format.html {
        # Tip
        @tip = tips.rand
        # Page name
        @pagename = "Readings for " + @vehicle.name
        # Data
        @purchases = @vehicle.vehicle_fuel_purchases.paginate :page => params[:page], :order => "purchased_on DESC"
      }
      format.xml {
        @purchases = @vehicle.vehicle_fuel_purchases.find(:all, :order => "purchased_on DESC")
      }
    end
  end

  def new
    @purchase = VehicleFuelPurchase.new
    respond_to do |format|
      format.html
      format.iphone { render_iphone }
      format.wml
    end
  end

  def create
    @purchase = @vehicle.vehicle_fuel_purchases.create(params[:vehicle_fuel_purchase])
    if @purchase.save
      mobile? ? redirect_to_main_page : redirect_to(user_vehicle_vehicle_fuel_purchases_path(@user, @vehicle))
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
    @purchase.update_attributes(params[:vehicle_fuel_purchase])
    if @purchase.save
      mobile? ? redirect_to_main_page : redirect_to(user_vehicle_vehicle_fuel_purchases_path(@user, @vehicle))
    else
      render :action => 'edit'
    end
  end

  def destroy
    @purchase.destroy
    redirect_to(user_vehicle_vehicle_fuel_purchases_path(@user, @vehicle))
  end

private

  def get_select_options
    @vehicle_fuel_types = @vehicle.vehicle_fuel_class.vehicle_fuel_types.find( :all, :order => 'name')
  end

  def get_vehicle
    @vehicle = @user.vehicles.find(params[:vehicle_id])
  end

  def get_purchase
    @purchase = @vehicle.vehicle_fuel_purchases.find(params[:id])
  end

  def tips
    [
      "Every time you buy fuel, add it here to track how much you've used.",
      "If you always fill up at the same point on your fuel gauge, the results will be more accurate."
    ]
  end

end