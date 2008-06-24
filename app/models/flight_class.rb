class FlightClass < ActiveRecord::Base
  validates_presence_of :name
  validates_numericality_of :scale_factor
  attr_accessible :name, :scale_factor
end
