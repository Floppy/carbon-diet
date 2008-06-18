class DefaultUnits < ActiveRecord::Migration

  def self.up
    add_column :countries, :vehicle_distance_unit_id, :integer, :limit => 10, :default => 1, :null => false
    add_column :countries, :vehicle_fuel_unit_id, :integer, :limit => 10, :default => 1, :null => false
    add_column :countries, :electricity_unit_id, :integer, :limit => 10, :default => 1, :null => false
    add_column :countries, :gas_unit_id, :integer, :limit => 10, :default => 1, :null => false
  end

  def self.down
    remove_column :countries, :vehicle_distance_unit_id
    remove_column :countries, :vehicle_fuel_unit_id
    remove_column :countries, :electricity_unit_id
    remove_column :countries, :gas_unit_id
  end

end
