class ElectricityUnit < ActiveRecord::Base
  # Validation
  validates_presence_of :name
  validates_presence_of :abbreviation
  validates_numericality_of :amount_in_kWh
  # Attributes
  attr_accessible :name, :abbreviation, :amount_in_kWh

  def name_with_abbreviation
    name + " (" + abbreviation + ")"
  end

end
