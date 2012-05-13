class GasReading < ActiveRecord::Base
  # Relationships
  belongs_to :gas_account
  # Validation
  validates :reading, :numericality => true
  validates_date :taken_on
  validates :taken_on, :uniqueness => {:scope => :gas_account}
  validates :validate_order
  # Attributes
  attr_accessible :taken_on, :reading

  # Delegation
  delegate :user, :to => :gas_account

  protected

  def validate_order
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
