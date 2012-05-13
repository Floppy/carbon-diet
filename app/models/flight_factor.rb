class FlightFactor < ActiveRecord::Base
  
  attr_accessible :name, :lower_limit, :upper_limit, :g_per_km

  def self.find_by_distance(distance)
    # Find a flight factor for the proposed distance
    where("((lower_limit IS NULL) AND (upper_limit > ?)) OR ((lower_limit <= ?) AND (upper_limit > ?)) OR ((lower_limit <= ?) AND (upper_limit IS NULL))", distance, distance, distance, distance)
  end

end
