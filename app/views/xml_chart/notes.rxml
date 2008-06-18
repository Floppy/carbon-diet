xml.chart do
  
  xml.chart_type "line"
  xml.chart_pref :fill_shape=>"true", :point_shape=>"square", :line_thickness=>"0"
  xml.chart_transition :type=>'dissolve'
  xml.chart_rect :positive_alpha=>"0", :negative_alpha=>"0"
  xml.axis_value :min=>'0', :max=>'1', :alpha=>"0"
  xml.axis_category :alpha=>"0"
  xml.axis_ticks :value_ticks=>'false', :category_ticks=>'false'
  xml.chart_grid_h :thickness=>'0'
  xml.chart_border :bottom_thickness=>'0', :left_thickness=>'0'
  xml.legend_rect :y=>'-1000'
  xml.chart_value :decimals=>'2', :position=>'cursor', :size=>'12', :color=>'000000', 
                  :background_color=>'ffffff', :alpha=>'75'

  xml.chart_data do
    xml.row do
      xml.null
      for item in @data
        xml.null
      end
    end
    xml.row do
      xml.null
      for item in @data
        item[:note].nil? ? xml.null : xml.number("1")
      end
    end
  end

  xml.chart_value_text do
    xml.row do
      xml.null
      for item in @data
        xml.null
      end
    end
    xml.row do
      xml.null
      for item in @data
        item[:note].nil? ? xml.null : xml.string(item[:note])
      end
    end
  end

  xml.series_color do
    xml.color "e69f32"
  end

end
