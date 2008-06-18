class VehicleDistanceUnit < ActiveRecord::Base
  # Validation
  validates_presence_of :name
  validates_presence_of :abbreviation
  validates_numericality_of :amount_in_km
  # Attributes
  attr_accessible :name, :abbreviation, :amount_in_km

  def name_with_abbreviation
    name + " (" + abbreviation + ")"
  end

end
