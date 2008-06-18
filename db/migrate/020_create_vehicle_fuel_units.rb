class CreateVehicleFuelUnits < ActiveRecord::Migration
  def self.up
    create_table :vehicle_fuel_units do |t|
      t.column :name, :string, :default => "", :null => false
      t.column :abbreviation, :string, :default => "", :null => false
      t.column :amount_in_l, :float, :default => 0.0, :null => false
    end
    rename_column :vehicle_fuel_purchases, :litres, :amount
    add_column :vehicles, :vehicle_fuel_unit_id, :integer, :limit => 10, :null => false, :default => 1
    VehicleFuelUnit.create(:name => "Litres", :abbreviation=>"l", :amount_in_l => "1")
    VehicleFuelUnit.create(:name => "Gallons (Imperial)", :abbreviation=>"gal", :amount_in_l => "4.54609188")
    VehicleFuelUnit.create(:name => "Gallons (US)", :abbreviation=>"gal", :amount_in_l => "3.7854118")
  end

  def self.down
    drop_table :vehicle_fuel_units
    remove_column :vehicles, :vehicle_fuel_unit_id
    rename_column :vehicle_fuel_purchases, :amount, :litres
  end
end
