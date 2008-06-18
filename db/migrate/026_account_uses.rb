class AccountUses < ActiveRecord::Migration

  def self.up
    add_column :gas_accounts, :used_for_heating, :boolean, :default => true, :null => false
    add_column :gas_accounts, :used_for_water, :boolean, :default => true, :null => false
    add_column :electricity_accounts, :used_for_heating, :boolean, :default => false, :null => false
    add_column :electricity_accounts, :used_for_water, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :gas_accounts, :used_for_heating
		remove_column :gas_accounts, :used_for_water
    remove_column :electricity_accounts, :used_for_heating
    remove_column :electricity_accounts, :used_for_water
  end
    
end
