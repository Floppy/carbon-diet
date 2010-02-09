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
    purchase = vehicle_fuel_purchases.find(:first, :order => "purchased_on")
    return Date::today if purchase.nil?
    return purchase.purchased_on
  end

  def old_style_emissions
    # Initialise result array
    emissiondata = EmissionArray.new
    # Analyse each purchase
    purchases = vehicle_fuel_purchases.find(:all, :order => "purchased_on")
    last_purchase = nil
    purchases.each do |purchase|
      # Calculate fuel used since last purchase
      unless last_purchase.nil?
        co2 = last_purchase.kg_of_co2
        days = purchase.purchased_on - last_purchase.purchased_on
        start = last_purchase.purchased_on
        start.succ
        # Add to result
        emissiondata << { :start => start,
                          :end => purchase.purchased_on,
                          :co2 => co2,
                          :days => days.to_i,
                          :co2_per_day => co2 / days }
      end
      last_purchase = purchase
      last_date = purchase.purchased_on
    end	
    # Add final entry
    if self.current and not emissiondata.empty?
      co2_per_day = emissiondata.last[:co2_per_day]
      days = Date::today - last_date
      if (last_purchase.kg_of_co2 / days) < co2_per_day
        co2_per_day = last_purchase.kg_of_co2 / days
      end
      emissiondata << { :start => last_date, 
                        :end => Date::today,
                        :co2 => co2_per_day * days, 
                        :days => days,
                        :co2_per_day => co2_per_day }
    end
    # Done
    return emissiondata
  end

  def new_style_emissions
    # Initialise result array
    emissiondata = EmissionArray.new
    # Analyse each purchase
    purchases = vehicle_fuel_purchases.find(:all, :order => "purchased_on")
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

  def emissions
    user.tester ? new_style_emissions : old_style_emissions
  end

  def has_enough_data_to_analyse
    count_purchases > 1
  end

  def count_purchases
    vehicle_fuel_purchases.count
  end

  def action_categories
    categories = []
    categories << ActionCategory.find_by_name("Travel")
  end

  def date_of_newest_data
    purchase = vehicle_fuel_purchases.find(:first, :order => "purchased_on DESC", :limit => 1)
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
