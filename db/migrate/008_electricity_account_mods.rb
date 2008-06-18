class ElectricityAccountMods < ActiveRecord::Migration

  def self.up
    add_column :electricity_accounts, :name, :string, :null => false, :default => "Electricity"
    remove_column :electricity_accounts, :active
  end

  def self.down
    remove_column :electricity_accounts, :name
    add_column :electricity_accounts, :active, :boolean, :default => true, :null => false
  end

end
