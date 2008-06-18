class ElectricitySupplierSource < ActiveRecord::Base
  # Relationships
  belongs_to :electricity_supplier
  belongs_to :electricity_source
  # Validation
  validates_numericality_of :percentage
  # Attributes
  attr_accessible :percentage, :electricity_supplier_id, :electricity_source_id
end
