module UsersHelper

  def news_feed(user, limit=10)
    feed = []
    # Get electricity reading data
    user.electricity_readings.limit(limit).order("taken_on DESC").where(:automatic => false).each do |reading|
      feed << {:image => 'electricity.png', 
               :when => reading.taken_on.to_time, 
               :text => "took a reading for '" + h(reading.electricity_account.name) + "'"}
    end
    # Get gas reading data
    user.gas_readings.limit(limit).order("taken_on DESC").each do |reading|
      feed << {:image => 'gas.png', 
               :when => reading.taken_on.to_time, 
               :text => "took a reading for '" + h(reading.gas_account.name) + "'"}
    end
    # Get fuel purchase data
    user.vehicle_fuel_purchases.limit(limit).order("purchased_on DESC").each do |purchase|
      feed << {:image => 'car.png', 
               :when => purchase.purchased_on.to_time, 
               :text => "bought some fuel for '" + h(purchase.vehicle.name) + "'"}
    end
    # Get note data
    user.all_notes(limit).each do |note|
      feed << {:image => 'note.png', 
               :when => note.date.to_time,
               :text => "wrote a note: '".html_safe + h(note.note) + "'"}
    end
    # Sort by date
    return feed.sort{ |x,y| y[:when] <=> x[:when] }.first(limit)
  end
  
end
