class CreateFlightFactors < ActiveRecord::Migration
  def self.up
    create_table :flight_factors do |t|
      t.column :name, :string, :null => false
      t.column :lower_limit, :integer, :null => true
      t.column :upper_limit, :integer, :null => true
      t.column :g_per_km, :float, :null => false
    end
    FlightFactor.create(:name => "Domestic", :lower_limit=>nil, :upper_limit=>1000, :g_per_km => "450")
    FlightFactor.create(:name => "Short Haul", :lower_limit=>1000, :upper_limit=>5000, :g_per_km => "300")
    FlightFactor.create(:name => "Long Haul", :lower_limit=>5000, :upper_limit=>nil, :g_per_km => "320")
  end

  def self.down
    drop_table :flight_factors
  end
end
