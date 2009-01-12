class AddCo2PerKwhToElectricitySuppliers < ActiveRecord::Migration
  def self.up
    add_column :electricity_suppliers, :g_per_kWh, :integer
  end

  def self.down
    remove_column :electricity_suppliers, :g_per_kWh
  end
end
