class Airport < ActiveRecord::Base

  def full_description
    icao_code + (iata_code.nil? ? "" : " / " + iata_code) + ": " + name + (name == location ? "" : ", " + location) + ", " + country
  end

  def self.find_by_full_description(description)
    self.find_by_icao_code(description.first(4))
  end
 
  def self.search(text, limit = 10)
    likestart = "#{text}%".downcase
    likesub = '%' + likestart
    Airport.limit(limit).order('icao_code ASC').where("LOWER(icao_code) LIKE ? OR LOWER(iata_code) LIKE ? OR LOWER(name) LIKE ? OR LOWER(location) LIKE ? OR LOWER(country) LIKE ?", likestart, likestart, likesub, likesub, likestart)
  end
 
  def self.import_from_partow_net_db   
    file = open("GlobalAirportDatabase.txt")          
    # For each line in the file
    file.read.each { |line|
      # Split into data fields
      fields = line.split(':')
      # Insert into database if sufficient data is present
      airport = Airport.find_by_icao_code(fields.first) || Airport.new
      airport.icao_code = fields[0]
      airport.iata_code = fields[1] unless fields[1] == "N/A"
      airport.name = fields[2].split(' ').map {|w| w.capitalize}.join(' ')
      airport.location = fields[3].split(' ').map {|w| w.capitalize}.join(' ')
      airport.country = fields[4].split(' ').map {|w| w.capitalize}.join(' ')
      airport.latitude = fields[5].to_f + (fields[6].to_f / 60) + (fields[7].to_f / 3600)
      airport.latitude = (airport.latitude * -1) if fields[8] == 'S'
      airport.longitude = fields[9].to_f + (fields[10].to_f / 60) + (fields[11].to_f / 3600)
      airport.longitude = (airport.longitude * -1) if fields[12] == 'W'
      unless (airport.latitude == 0.0 or airport.longitude == 0.0)
        airport.save!
      end
    }
  end

end
