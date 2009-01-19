xml.instruct!
xml.flights do

  for flight in @flights
    
    xml.flight do
      xml.route do
        xml.from flight.from_airport.icao_code
        xml.to flight.to_airport.icao_code
      end
      xml.passengers flight.passengers
      xml.class flight.flight_class.name
      xml.outbound_on flight.outbound_on.xmlschema
      xml.return_on flight.return_on.xmlschema if flight.return_on
    end
    
  end

end