class ElectricityAccount < ActiveRecord::Base
  # Relationships
  belongs_to :user
  belongs_to :electricity_supplier
  has_many :electricity_readings
  belongs_to :electricity_unit
  has_many :notes, :as => :notatable
  # Validation
  validates_presence_of :name
  # Attributes
  attr_accessible :name, :electricity_supplier_id, :night_rate, :current, :electricity_unit_id, :used_for_heating, :used_for_water

  def destroy
    electricity_readings.each { |x| x.destroy }
    notes.each { |x| x.destroy }
    super
  end

  def kg_per_kwh
    electricity_supplier.kg_per_kwh
  end

  def start_date
    reading = electricity_readings.find(:first, :order => "taken_on")
    return Date::today if reading.nil?
    return reading.taken_on
  end
 
  def emissions
    # Initialise result array
    emissiondata = EmissionArray.new
    # Create "last reading" trackers
    last_kWh = 0;
    last_date = 0;
    # Analyse each reading
    readings = electricity_readings.find(:all, :order => "taken_on")
    readings.each do |reading|
      # Calculate electricity used since last reading
      kWh_total = reading.kwh_day
      if reading.kwh_night
        kWh_total += reading.kwh_night
      end
      if last_kWh != 0
        kWh_used = kWh_total - last_kWh
      else
        kWh_used = 0
      end
      # Add to result
      if (kWh_used != 0)
        days = reading.taken_on - last_date
        co2 = kWh_used * kg_per_kwh
        emissiondata << { :start => last_date, 
                          :end => reading.taken_on,
                          :co2 => co2, 
                          :days => days.to_i,
                          :co2_per_day => co2 / days }
      end
      # Store data for next time round
      last_kWh = kWh_total
      last_date = reading.taken_on
    end	
    # Add final entry
    if self.current and not emissiondata.empty?
      co2_per_day = emissiondata.last[:co2_per_day]
      days = Date::today - last_date
      emissiondata << { :start => last_date, 
                        :end => Date::today,
                        :co2 => co2_per_day * days, 
                        :days => days,
                        :co2_per_day => co2_per_day }
    end
    # Done
    return emissiondata
  end

  def has_enough_data_to_analyse
    count_readings > 1
  end

  def count_readings
    electricity_readings.count
  end

  def action_categories
    categories = []
    categories << ActionCategory.find_by_name("Electricity")
    categories << ActionCategory.find_by_name("Heating") if used_for_heating 
    categories << ActionCategory.find_by_name("Hot Water") if used_for_water
    return categories
  end

  def date_of_newest_data
    reading = electricity_readings.find(:first, :order => "taken_on DESC", :limit => 1) 
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
    'electricity.png'
  end

end
