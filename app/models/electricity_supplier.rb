class ElectricitySupplier < ActiveRecord::Base
  # Relationships
  belongs_to :country
  has_many :electricity_supplier_sources
  has_many :electricity_sources, :through => :electricity_supplier_sources
  has_many :electricity_accounts
  # Validation
  validates_presence_of :name
  # Attributes
  attr_accessible :name, :country_id, :company_url, :info_url, :aliases, :default

  def sources_ok?
    return (total_sources == 100.0)
  end

  def total_sources
    total = 0.0
    for source in electricity_supplier_sources
      total += source.percentage.to_f
    end
    return total
  end

  def kg_per_kWh  
    total = 0
    for source in electricity_supplier_sources
      total += source.electricity_source.g_per_kWh * (source.percentage.to_f / 100) / 1000
    end
    return total
  end

  def destroy
    electricity_supplier_sources.each { |x| x.destroy }
    super
  end
 
  def self.default(country)
    find_by_country_id_and_default(country.id, true)
  end

end
