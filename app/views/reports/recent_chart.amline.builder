xml.chart do

  xml.series do
    unless @data.empty?
      xid = 0
      @data[0][:dates].each do |date|
        xml.value date, :xid => xid
        xid += 1
      end
    end
  end

  xml.graphs do
    gid = 0
    @data.reverse.each do |dataset|
      options = { :gid=>gid, :title=>dataset[:name], :color=>dataset[:colour] }      
      options[:fill_alpha] = '50' if dataset[:name] == 'Total'      
      xml.graph options do
        xid = 0
        dataset[:data].each do |value|
          options = {:xid => xid}
          if dataset[:notes] && dataset[:notes][xid] && dataset[:notes][xid][:note]
            options[:description] = dataset[:notes][xid][:note]
            options[:bullet] = "images/note.png"
          end          
          xml.value number_with_precision(value, :precision => 2), options
          xid += 1
        end
      end
      gid += 1
    end
  end

end
