xml.vehicle do

  xml.name @vehicle.name
  xml.fuel_class @vehicle.vehicle_fuel_class.name
  xml.fuel_unit @vehicle.vehicle_fuel_unit.name
  xml.distance_unit @vehicle.vehicle_distance_unit.name
  xml.current @vehicle.current
  
  @purchases.each do |purchase|
    xml.purchase do
      xml.purchased_on purchase.purchased_on.xmlschema
      xml.amount purchase.amount
      xml.distance purchase.distance if purchase.distance
      xml.fuel_type purchase.vehicle_fuel_type.name
    end
  end

end