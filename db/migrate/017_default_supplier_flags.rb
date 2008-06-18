class DefaultSupplierFlags < ActiveRecord::Migration

  def self.up
    add_column :electricity_suppliers, :default, :boolean, :default => false
    add_column :gas_suppliers, :default, :boolean, :default => false
    add_column :vehicle_fuel_types, :default, :boolean, :default => false
  end

  def self.down
    remove_column :electricity_suppliers, :default
    remove_column :gas_suppliers, :default
    remove_column :vehicle_fuel_type, :default
  end

end
