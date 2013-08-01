class Vehicle < ActiveRecord::Base
  # Relationships
  belongs_to :user
  belongs_to :vehicle_fuel_class
  has_many :vehicle_fuel_purchases
  belongs_to :vehicle_fuel_unit
  belongs_to :vehicle_distance_unit
  has_many :notes, :as => :notatable
  # Validation
  validates_presence_of :name
  # Attributes
  attr_accessible :name, :vehicle_fuel_class_id, :current, :vehicle_fuel_unit_id, :vehicle_distance_unit_id

  def destroy
    vehicle_fuel_purchases.each { |x| x.destroy }
    notes.each { |x| x.destroy }
    super
  end

  def start_date
    purchase = vehicle_fuel_purchases.order("purchased_on").first
    return Date::today if purchase.nil?
    return purchase.purchased_on
  end

  def emissions
    # Initialise result array
    emissiondata = EmissionArray.new
    # Analyse each purchase
    purchases = vehicle_fuel_purchases.order("purchased_on")
    purchases.each_index do |x|
      # Calculate fuel used since last purchase
      purchase = purchases[x]
      next_purchase = purchases[x+1]
      unless next_purchase.nil?
        co2 = next_purchase.kg_of_co2
        days = next_purchase.purchased_on - purchase.purchased_on
        start = purchase.purchased_on
        start.succ
        # Add to result
        emissiondata << { :start => start,
                          :end => next_purchase.purchased_on,
                          :co2 => co2,
                          :days => days.to_i,
                          :co2_per_day => co2 / days }
      end
    end
    # Add final entry
    if self.current and not emissiondata.empty?
      co2_per_day = emissiondata.last[:co2_per_day]
      days = Date::today - purchases.last.purchased_on
      if (purchases.last.kg_of_co2 / days) < co2_per_day
        co2_per_day = purchases.last.kg_of_co2 / days
      end
      emissiondata << { :start => purchases.last.purchased_on,
                        :end => Date::today,
                        :co2 => co2_per_day * days,
                        :days => days,
                        :co2_per_day => co2_per_day }
    end
    # Done
    return emissiondata
  end

  def has_enough_data_to_analyse
    count_purchases > 1
  end

  def count_purchases
    vehicle_fuel_purchases.count
  end

  def date_of_newest_data
    purchase = vehicle_fuel_purchases.order("purchased_on DESC").limit(1).first
    if purchase.nil?
      return 100.years.ago.to_date
    else
      return purchase.purchased_on.to_date
    end
  end

  def image
    'car.png'
  end

end
