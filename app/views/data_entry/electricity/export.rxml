xml.electricity_account do

  xml.name @account.name
  xml.supplier @account.electricity_supplier.name
  xml.dual_rate @account.night_rate
  xml.unit @account.electricity_unit.name
  xml.current @account.current
  
  xml.uses do
    xml.heating @account.used_for_heating
    xml.hot_water @account.used_for_water
  end
  
  for reading in @account.electricity_readings
    xml.reading do
      xml.taken_on reading.taken_on.xmlschema
      xml.reading do
        xml.day reading.reading_day
        xml.night reading.reading_night if @account.night_rate
      end
    end
  end

end