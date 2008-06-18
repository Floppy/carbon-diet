require 'tempfile'

module Mogrify

  class Image    
 
    def initialize(data)
      @data = data
    end
 
    def self.from_file(file, identify=true)
      if identify
        return nil unless system("identify #{file}")
      end
      File.open(file, "rb") { |f| self.new(f.read) }
    end
 
    def to_file(filename)
      File.open(filename, "wb") { |file| file.write(@data) }
    end

    def self.from_blob(data)
      # Write blob data to temporary file
      tempfile = Tempfile.new("carbondiet-mogrify")
      tempfile.binmode 
      tempfile.write(data)
      tempfile.close
      # Check that the file is a valid image before we allow creation of a new object
      valid = system("identify #{tempfile.path}")
      # Remove the temporary file
      tempfile.delete
      # Create object if valid
      return nil unless valid
      self.new(data)
    end
    
    def resize(width, height)
      # Write data to temp file
      tempfile = Tempfile.new("carbondiet-mogrify")
      tempfile.binmode 
      tempfile.write(@blob)
      tempfile.close
      # Mogrify the file
      success = system("mogrify -resize #{width}x#{height} #{tempfile.path}")
      # Load resized blob back in from temp file
      return nil unless success
      newimage =  Mogrify::Image::from_file(tempfile.path, false)
      tempfile.delete
      return newimage
    end
    
  end

end
