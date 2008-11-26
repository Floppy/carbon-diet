class AddAutomaticFlagToElectricityReadings < ActiveRecord::Migration
  def self.up
    add_column :electricity_readings, :automatic, :boolean, :default => false
  end

  def self.down
    remove_column :electricity_readings, :automatic
  end
end
