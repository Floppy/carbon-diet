class GasReading < ActiveRecord::Base
  # Relationships
  belongs_to :gas_account
  # Validation
  validates_numericality_of :reading
  validates_date :taken_on
  # Attributes
  attr_accessible :taken_on, :reading

  # Delegation
  delegate :user, :to => :gas_account

  protected

  def validate_on_create
    # Make sure we have not already got a reading for the date entered
    existing = gas_account.gas_readings.find(:first, 
                                             :conditions => ["taken_on = ?", taken_on]) 
    errors.add("You can only enter one reading per day!", "Edit the existing entry if that's what you really meant to do.") unless existing.nil?
  end

  def validate
    # Find reading immediately before this one, and the one immediately after
    previous = gas_account.gas_readings.find(:first, 
                                             :conditions => ["taken_on < ?", taken_on],
                                             :order => "taken_on DESC") 
    subsequent = gas_account.gas_readings.find(:first, 
                                               :conditions => ["taken_on > ?", taken_on])
    # Check readings, make sure they're in sequence
    errors.add("Reading is lower than its preceeding value!", "Are you sure it's correct?") unless previous.nil? || previous.reading <= reading
    errors.add("Reading is higher than its subsequent value!", "Are you sure it's correct?") unless subsequent.nil? || subsequent.reading >= reading
  end

public

  def m3
    reading * gas_account.gas_unit.amount_in_m3
  end

end
