xml.gas_account do

  xml.name @account.name
  xml.supplier @account.gas_supplier.name
  xml.unit @account.gas_unit.name
  xml.current @account.current
  
  xml.uses do
    xml.heating @account.used_for_heating
    xml.hot_water @account.used_for_water
  end

  for reading in @account.gas_readings
    xml.reading do
      xml.taken_on reading.taken_on.xmlschema
      xml.reading reading.reading
    end
  end

end