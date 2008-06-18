class ModifyElectricityReadings < ActiveRecord::Migration

  def self.up
    change_column :electricity_readings, :kWh_night, :float, :default => 0.0, :null => false
  end

  def self.down
    change_column :electricity_readings, :kWh_night, :float
  end

end
