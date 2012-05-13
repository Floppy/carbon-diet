class ElectricityReading < ActiveRecord::Base
  
  # Relationships
  belongs_to :electricity_account

  # Validation
  validates :reading_day, :numericality => true
  validates :reading_night, :numericality => true
  validates_date :taken_on
  validates :taken_on, :uniqueness => {:scope => :gas_account}
  validate :validate_order, :on => [:create, :update]

  # Attributes
  attr_accessible :taken_on, :reading_day, :reading_night, :automatic

  # Delegation
  delegate :user, :to => :electricity_account

  protected
  
  def validate_order
    # Find reading immediately before this one, and the one immediately after
    previous = electricity_account.electricity_readings.where("taken_on < ?", taken_on).order("taken_on DESC").first
    subsequent = electricity_account.electricity_readings.where("taken_on > ?", taken_on).order("taken_on ASC").first
    # Check readings, make sure they're in sequence
    errors.add("Day reading (#{reading_day}) is lower than its preceeding value (#{previous.reading_day})!", "Are you sure it's correct?") unless previous.nil? || previous.reading_day <= reading_day
    errors.add("Day reading (#{reading_day})  is higher than its subsequent value! (#{subsequent.reading_day})", "Are you sure it's correct?") unless subsequent.nil? || subsequent.reading_day >= reading_day
    errors.add("Night reading (#{reading_night}) is lower than its preceeding value (#{previous.reading_night})!", "Are you sure it's correct?") unless previous.nil? || previous.reading_night <= reading_night
    errors.add("Night reading (#{reading_night}) is higher than its subsequent value (#{subsequent.reading_night})!", "Are you sure it's correct?") unless subsequent.nil? || subsequent.reading_night >= reading_night
  end

public

  def kwh_day
    reading_day * electricity_account.electricity_unit.amount_in_kWh
  end

  def kwh_night
    reading_night * electricity_account.electricity_unit.amount_in_kWh
  end

end
