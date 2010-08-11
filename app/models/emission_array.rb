class EmissionArray < Array
  
  def calculate_graph(days, skip=1)
    graph = GraphData.new
    graph[:values] = []
    graph[:dates] = []
    # Calculate boundary dates
    last_day = Date::today
    first_day = last_day - days + 1
    # For each day in between boundaries, add up emissions
    day = first_day
    offset = 0
    while day <= last_day 
      graph[:values] << self.calculate_day(day)
      date = Date::ABBR_MONTHNAMES[day.month] + " " + day.day.to_s
      if days > 180
	date += " " + day.year.to_s.last(2)
      end
      graph[:dates] << date
      day += skip;
      offset += 1;
    end
    return graph
  end

  def calculate_total_over_period(days)
    return 0 if self.empty? 
    total = 0.0
    dayscounted = 0
    firstday = Date::today - days
    # Move to start of emission data if we're before it
    if firstday <= self.first[:start]
      firstday = self.first[:start]
    end
    # Handle all data
    self.each do |entry|
      if firstday > entry[:start] and firstday <= entry[:end]
        tmp = entry[:end] - firstday + 1
        total += entry[:co2_per_day] * tmp
        dayscounted += tmp
      elsif firstday <= entry[:start]
        total += entry[:co2]
        dayscounted += entry[:days]    
      end
    end
    # Done
    divisor = days
    average = (divisor > 0) ? (total / divisor) : 0
    return { :total => total, :days => divisor, :perday => average, :perannum => (average * 365) }
  end

  def calculate_total()
    if self.empty? 
      return 0
    end
    days = Date::today - self.first[:start]
    self.calculate_total_over_period(days)
  end

protected

  def calculate_day(day)
    if self.empty? or day <= self.first[:start] or day > self.last[:end]
      return nil
    end
    self.each do |entry|
      if day > entry[:start] and day <= entry[:end]
        return entry[:co2_per_day]
      end
    end
    return nil
  end  

end
