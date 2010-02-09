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
    electricity_supplier_sources.each do |source|
      total += source.percentage.to_f
    end
    return total
  end

  def kg_per_kWh
    # Use explicit g_per_kWh figure if set
    return g_per_kWh.to_f / 1000.0 if g_per_kWh
    # Otherwise, calculate from source mix
    total = 0
    electricity_supplier_sources.each do |source|
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
