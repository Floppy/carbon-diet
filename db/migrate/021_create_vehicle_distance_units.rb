class CreateVehicleDistanceUnits < ActiveRecord::Migration

  def self.up
    create_table :vehicle_distance_units do |t|
      t.column :name, :string, :default => "", :null => false
      t.column :abbreviation, :string, :default => "", :null => false
      t.column :amount_in_km, :float, :default => 0.0, :null => false
    end
    add_column :vehicles, :vehicle_distance_unit_id, :integer, :limit => 10, :null => false, :default => 1
    add_column :vehicle_fuel_purchases, :distance, :float, :null => true
    VehicleDistanceUnit.create(:name => "Kilometres", :abbreviation=>"km", :amount_in_km => "1")
    VehicleDistanceUnit.create(:name => "Miles", :abbreviation=>"mi", :amount_in_km => "1.609344")
  end

  def self.down
    drop_table :vehicle_distance_units
    remove_column :vehicles, :vehicle_distance_unit_id
    remove_column :vehicle_fuel_purchases, :distance
  end

end
