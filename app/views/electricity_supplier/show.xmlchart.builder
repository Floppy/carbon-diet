xml.chart do
  
  xml.chart_type "pie"

  xml.chart_value :position=>'cursor', :size=>'12', :color=>'000000', :background_color=>'ffffff', :alpha=>'75'

  xml.chart_data do
    xml.row do 
      xml.null
      @supplier.electricity_supplier_sources.each do |source|
        xml.string source.electricity_source.source
      end
    end
    xml.row do
      xml.string @supplier.name
      @supplier.electricity_supplier_sources.each do |source|
        xml.number source.percentage
      end
    end
  end

  xml.chart_value_text do
    xml.row do 
      xml.null
      @supplier.electricity_supplier_sources.each do |source|
        xml.null
      end
    end
    xml.row do
      xml.string @supplier.name
      @supplier.electricity_supplier_sources.each do |source|
        xml.string source.electricity_source.source + ": " + number_with_precision(source.percentage, :precision => 1) + "%"
      end
    end
  end

  colours = {
    "Coal" => "505050",
    "Gas" => "00ffff",
    "Renewable" => "00dd00",
    "Oil" => "0000ff",
    "Nuclear" => "ff0000",
    "Hydroelectric" => "007f7f"
  }

  xml.series_color do
    @supplier.electricity_supplier_sources.each do |source|
      if colours[source.electricity_source.source]
        xml.color colours[source.electricity_source.source]
      else
        xml.color "ffff00"
      end      
    end
  end

end
