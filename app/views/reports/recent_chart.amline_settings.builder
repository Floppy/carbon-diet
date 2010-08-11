xml.settings do

  xml.decimals_separator '.'
  xml.thousands_separator ','
  xml.redraw 'true'
  
  xml.indicator do
    xml.one_y_balloon 'true'
  end

  xml.values do
    xml.y_left do
      xml.max @max      
      xml.strict_min_max 'true' 
    end
  end
  
  xml.labels do
    xml.label do
      xml.rotate 'false'
      xml.align 'center'  
      xml.text 'Daily Carbon Footprint (in kg CO2-e)'
    end
  end

end
