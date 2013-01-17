module CarbonDiet
  class Application
    def self.style
      ENV['STYLE'] || 'default'
    end
  end
end