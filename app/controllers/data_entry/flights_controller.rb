class DataEntry::FlightsController < AuthenticatedController
 
  def index
    # Data
    @flight_pages, @flights = paginate :flights, {:per_page => 20, :conditions => ["user_id = ?", @current_user.id], :order => "outbound_on DESC"}
  end

  def edit
    @flight = params[:id] ? @current_user.flights.find_by_id(params[:id]) : Flight.new
    @classes = FlightClass.find( :all )
    if request.post?
      @flight.user_id = @current_user.id      
      @flight.update_attributes(params[:flight])
      if @flight.save
        @current_user.update_stored_statistics!
        redirect_to :action => 'index'
      end
    end
  end

  def export
    @flights = @current_user.flights
    # Render
    headers["Content-Type"] = "application/xml; charset=utf-8" 
    render :action => "export.rxml", :layout => false
  end

  def destroy
    flight = @current_user.flights.find_by_id(params[:id])
    flight.destroy if flight
    @current_user.update_stored_statistics!
    redirect_to :action => 'index'
  end

  def auto_complete_for_flight_from_airport
    search_airports(params[:flight][:from_airport])
  end

  def auto_complete_for_flight_to_airport
    search_airports(params[:flight][:to_airport])
  end
  
private

  def search_airports(search)
    @airports = Airport.search(search, 10)
    render :partial => 'airport_autocomplete'
  end
  
end
