class FlightsController < BelongsToUser
  before_filter :get_flight, :only => [:edit, :update, :destroy]
  skip_before_filter :get_user, :only => [:auto_complete_for_flight_from_airport, :auto_complete_for_flight_to_airport]

  def index
    respond_to do |format|
      format.html {
        @flights = @user.flights.paginate :per_page => 20, :order => "outbound_on DESC", :page => params[:page]
      }
      format.xml {
        @flights = @user.flights.find :all, :order => "outbound_on DESC"
      }
      format.ammap {
        @flights = @user.flights.find :all, :order => "outbound_on DESC"
        render :layout => false
      }
    end
  end

  def new
    @flight = Flight.new
    @classes = FlightClass.find( :all )
  end

  def create
    fix_missing_date_components
    @flight = @user.flights.create(params[:flight])
    if @flight.save
      redirect_to :action => 'index'
    else
      @classes = FlightClass.find( :all )
      render :action => 'new'
    end
  end

  def edit
    @classes = FlightClass.find( :all )
  end

  def update
    fix_missing_date_components
    @flight.update_attributes(params[:flight])
    if @flight.save
      redirect_to :action => 'index'
    else
      @classes = FlightClass.find( :all )
      render :action => 'edit'
    end
  end

  def destroy
    @flight.destroy
    redirect_to :action => 'index'
  end

  def auto_complete_for_flight_from_airport
    search_airports(params[:flight][:from_airport])
  end

  def auto_complete_for_flight_to_airport
    search_airports(params[:flight][:to_airport])
  end
  
private

  def get_flight
    @flight = @user.flights.find_by_id(params[:id])
    render_http_code 404 if @flight.nil?
  end

  def search_airports(search)
    @airports = Airport.search(search, 10)
    render :partial => 'airport_autocomplete'
  end

  def fix_missing_date_components
    if !params[:flight]['return_on(1i)'].blank? || !params[:flight]['return_on(2i)'].blank? || !params[:flight]['return_on(3i)'].blank?
      params[:flight]['return_on(1i)'] = params[:flight]['outbound_on(1i)'] if params[:flight]['return_on(1i)'].blank?
      params[:flight]['return_on(2i)'] = params[:flight]['outbound_on(2i)'] if params[:flight]['return_on(2i)'].blank?
      params[:flight]['return_on(3i)'] = params[:flight]['outbound_on(3i)'] if params[:flight]['return_on(3i)'].blank?
    end
  end
  
end
