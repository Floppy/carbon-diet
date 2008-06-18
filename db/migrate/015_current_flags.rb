class CurrentFlags < ActiveRecord::Migration

  def self.up
    add_column :electricity_accounts, :current, :boolean, :default => true, :null => false
    remove_column :gas_accounts, :active
    add_column :gas_accounts, :current, :boolean, :default => true, :null => false
    remove_column :vehicles, :active
    add_column :vehicles, :current, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :electricity_accounts, :current
    remove_column :gas_accounts, :current
    add_column :gas_accounts, :active, :boolean, :default => true, :null => false
    remove_column :vehicles, :current
    add_column :vehicles, :active, :boolean, :default => true, :null => false
  end

end
