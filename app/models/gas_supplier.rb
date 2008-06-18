class GasSupplier < ActiveRecord::Base
  # Relationships
  belongs_to :country
  has_many :gas_accounts
  # Validation
  validates_presence_of :name
  validates_numericality_of :g_per_m3
  # Attributes
  attr_accessible :name, :country_id, :g_per_m3, :default

  def self.default(country)
    find_by_country_id_and_default(country.id, true)
  end

end
