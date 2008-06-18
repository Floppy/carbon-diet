class VehicleFuelPurchase < ActiveRecord::Base
  # Relationships
  belongs_to :vehicle
  belongs_to :vehicle_fuel_type
  # Validation
  validates_numericality_of :amount
  # Attributes
  attr_accessible :purchased_on, :amount, :vehicle_fuel_type_id, :distance

  def validate
    unless distance.nil?
      # Find distance immediately before this one, and the one immediately after
      previous = vehicle.vehicle_fuel_purchases.find(:first, 
                                                     :conditions => ["purchased_on < ? AND distance IS NOT NULL", purchased_on],
                                                     :order => "purchased_on DESC") 
      subsequent = vehicle.vehicle_fuel_purchases.find(:first, 
                                                      :conditions => ["purchased_on > ? AND distance IS NOT NULL", purchased_on],
                                                      :order => "purchased_on ASC") 
      # Check distances, make sure they're in sequence
      errors.add("Distance is lower than its preceeding value!", "Are you sure it's correct?") unless previous.nil? || previous.distance <= distance
      errors.add("Distance is higher than its subsequent value!", "Are you sure it's correct?") unless subsequent.nil? || subsequent.distance >= distance
    end
  end

  def kg_of_co2
    vehicle_fuel_type.g_per_l * litres / 1000
  end

  def litres
    amount * vehicle.vehicle_fuel_unit.amount_in_l
  end

end
