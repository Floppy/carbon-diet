module WmlHelper

  def wml_date_select(date = Date.today)
    start_year = date.year-5
    end_year = date.year+5
    wml_select('day', (1..31).to_a, date.day) +
      wml_select('month', (1..12).to_a.map{|x|Date::ABBR_MONTHNAMES[x]}, Date::ABBR_MONTHNAMES[date.month], Proc.new{|x|Date::ABBR_MONTHNAMES.index(x)}) +
      wml_select('year', (start_year..end_year).to_a, date.year)
  end
  
  def wml_select(name, values, default=nil, value_func = nil, value_text = nil)
    ivalue = values.index(default)
    wml = "<select name='#{name}'"
    wml << " ivalue='#{ivalue+1}'" if ivalue
    wml << ">"
    ivalue = nil
    values.each_index do |x|
      if value_text
        text = values[x].send(value_text)
      else
        text = values[x]
      end
      if value_func
        if value_func.is_a? Proc
          ivalue = value_func.call(values[x])
        else
          ivalue = values[x].send(value_func)
        end
      end
      if ivalue
        wml << "<option value='#{ivalue}'>#{text}</option>"
      else
        wml << "<option>#{text}</option>"
      end
    end
    wml << "</select>"
  end

end