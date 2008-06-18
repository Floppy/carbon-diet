class GasAccount < ActiveRecord::Base
  # Relationships
  belongs_to :user
  belongs_to :gas_supplier
  has_many :gas_readings
  belongs_to :gas_unit
  has_many :notes, :as => :notatable
  # Validation
  validates_presence_of :name
  # Attributes
  attr_accessible :name, :gas_supplier_id, :current, :gas_unit_id, :used_for_heating, :used_for_water

  def destroy
    gas_readings.each { |x| x.destroy }
    notes.each { |x| x.destroy }
    super
  end

  def kg_per_m3  
    gas_supplier.g_per_m3 / 1000.0
  end

  def start_date
    reading = gas_readings.find(:first, :order => "taken_on")
    return Date::today if reading.nil?
    return reading.taken_on
  end

  def emissions
    # Initialise result array
    emission_array = EmissionArray.new
    # Create "last reading" trackers
    last_m3 = 0;
    last_date = 0;
    # Analyse each reading
    readings = gas_readings.find(:all, :order => "taken_on")
    for reading in readings
      # Calculate gas used since last reading
      if last_m3 != 0
        m3_used = reading.m3 - last_m3
      else
        m3_used = 0
      end
      # Add to result
      if (m3_used != 0)
        days = reading.taken_on - last_date
        co2 = m3_used * kg_per_m3
        emission_array << { :start => last_date, 
                            :end => reading.taken_on,
                            :co2 => co2, 
                            :days => days.to_i,
                            :co2_per_day => co2 / days }
      end
      # Store data for next time round
      last_m3 = reading.m3
      last_date = reading.taken_on      
    end	
    # Add final entry
    if self.current and not emission_array.empty?
      co2_per_day = emission_array.last[:co2_per_day]
      days = Date::today - last_date
      emission_array << { :start => last_date, 
                          :end => Date::today,
                          :co2 => co2_per_day * days, 
                          :days => days,
                          :co2_per_day => co2_per_day }
    end
    # Done
    return emission_array 
  end

  def has_enough_data_to_analyse
    count_readings > 1
  end

  def count_readings
    gas_readings.count
  end

  def action_categories
    categories = []
    categories << ActionCategory.find_by_name("Heating") if used_for_heating 
    categories << ActionCategory.find_by_name("Hot Water") if used_for_water
    return categories
  end

  def date_of_newest_data
    reading = gas_readings.find(:first, :order => "taken_on DESC", :limit => 1) 
    if reading.nil?
      return 100.years.ago.to_date
    else
      return reading.taken_on.to_date
    end
  end

  def needs_more_data
    return date_of_newest_data < 1.week.ago.to_date
  end

  def image
    'gas.png'
  end

end
