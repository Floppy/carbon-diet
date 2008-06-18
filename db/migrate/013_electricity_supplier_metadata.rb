class ElectricitySupplierMetadata < ActiveRecord::Migration

  def self.up
    add_column :electricity_suppliers, :company_url, :string, :null => true
    add_column :electricity_suppliers, :info_url, :string, :null => true 
    add_column :electricity_suppliers, :aliases, :string, :null => true
  end 

  def self.down
    remove_column :electricity_suppliers, :company_url
    remove_column :electricity_suppliers, :info_url
    remove_column :electricity_suppliers, :aliases
  end

end
