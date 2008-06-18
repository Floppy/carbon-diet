class ElectricitySource < ActiveRecord::Base
  # Relationships
  belongs_to :country
  has_many :electricity_supplier_sources
  has_many :electricity_suppliers, :through => :electricity_supplier_sources
  # Validation
  validates_presence_of :source
  validates_numericality_of :g_per_kWh
  # Attributes
  attr_accessible :source, :g_per_kWh, :country_id

  def destroy
    electricity_supplier_sources.each { |x| x.destroy }
    super
  end

  def to_label
    "#{source} (#{country.abbreviation})"    
  end

end
