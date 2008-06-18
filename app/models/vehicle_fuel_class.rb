class VehicleFuelClass < ActiveRecord::Base
  # Relationships
  belongs_to :country
  has_many :vehicle_fuel_types
  # Validation
  validates_presence_of :name
  # Attributes
  attr_accessible :name, :country_id

  def to_label
    "#{name} (#{country.abbreviation})"
  end

end