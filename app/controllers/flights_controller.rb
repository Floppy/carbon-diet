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
      }
    end
  end

  def new
    @flight = Flight.new
    @classes = FlightClass.find( :all )
  end

  def create
    @flight = @user.flights.create(params[:flight])
    if @flight.save
      @user.update_stored_statistics!
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
    @flight.update_attributes(params[:flight])
    if @flight.save
      @user.update_stored_statistics!
      redirect_to :action => 'index'
    else
      @classes = FlightClass.find( :all )
      render :action => 'edit'
    end
  end

  def destroy
    @flight.destroy
    @user.update_stored_statistics!
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
  
end
