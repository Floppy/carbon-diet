class Country < ActiveRecord::Base
  # Relationships
  has_many :users
  has_many :electricity_suppliers
  has_many :electricity_sources
  has_many :gas_suppliers
  has_many :vehicle_fuel_classes
  belongs_to :vehicle_fuel_unit
  belongs_to :vehicle_distance_unit
  belongs_to :electricity_unit
  belongs_to :gas_unit
  # Validation
  validates_presence_of :name
  validates_presence_of :abbreviation
  # Attributes
  attr_accessible :name, :abbreviation, :flag_image, :vehicle_fuel_unit_id, :visible
  attr_accessible :vehicle_distance_unit_id, :electricity_unit_id, :gas_unit_id

  def self.list
    countries = []
    # Create 'other' country
    other = Country.new
    other.id = 0
    other.name = "-- Other --"
    other.abbreviation = "?"
    countries << other
    # Get the rest from the DB
    countries += self.order("name")
  end

end
