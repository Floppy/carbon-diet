class Flight < ActiveRecord::Base

  belongs_to :from_airport, :class_name => 'Airport', :foreign_key => 'from_airport_id'
  belongs_to :to_airport, :class_name => 'Airport', :foreign_key => 'to_airport_id'
  belongs_to :flight_class
  attr_accessible :outbound_on, :return_on, :from_airport, :to_airport, :passengers, :flight_class_id
  validates_presence_of :user_id, :outbound_on, :from_airport_id, :to_airport_id, :flight_class_id
  validates_date :outbound_on
  validates_date :return_on, :allow_nil => true, :on_or_after => :outbound_on

  def from_airport=(description)
    write_attribute :from_airport_id, Airport.find_by_full_description(description).id
  rescue
    write_attribute :from_airport_id, nil
  end
  
  def to_airport=(description)
    write_attribute :to_airport_id, Airport.find_by_full_description(description).id
  rescue
    write_attribute :to_airport_id, nil
  end

  def kg_of_co2
    distance = km
    kg_per_km = FlightFactor.find_by_distance(distance).g_per_km / 1000.0
    km * kg_per_km * flight_class.scale_factor * passengers
  end

  def km
    r = 6378.1 # Radius of Earth in km
    a1 = from_airport.latitude / 360 * (2 * Math::PI)
    b1 = from_airport.longitude / 360 * (2 * Math::PI)
    a2 = to_airport.latitude / 360 * (2 * Math::PI)
    b2 = to_airport.longitude / 360 * (2 * Math::PI)
    oneway = Math.acos(Math.cos(a1)*Math.cos(b1)*Math.cos(a2)*Math.cos(b2) + Math.cos(a1)*Math.sin(b1)*Math.cos(a2)*Math.sin(b2) + Math.sin(a1)*Math.sin(a2)) * r
    oneway * (return_on.nil? ? 1 : 2)
  rescue
    0
  end

end
