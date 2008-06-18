class VehicleFuelType < ActiveRecord::Base
  # Relationships
  belongs_to :vehicle_fuel_class
  # Validation
  validates_presence_of :name
  validates_numericality_of :g_per_l
  # Attributes
  attr_accessible :name, :g_per_l, :vehicle_fuel_class_id, :default

  def self.default(fuelclass)
    find_by_vehicle_fuel_class_id_and_default(fuelclass.id, true)
  end

end
