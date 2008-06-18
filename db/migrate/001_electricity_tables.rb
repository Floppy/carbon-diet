class ElectricityTables < ActiveRecord::Migration

  def self.up

    # electricity account table
    create_table :electricity_accounts do |t|
      t.column :electricity_supplier_id, :integer, :limit => 10, :default => 0, :null => false
      t.column :user_id, :integer, :limit => 10, :default => 0, :null => false
      t.column :active, :boolean, :default => true, :null => false
      t.column :night_rate, :boolean, :default => false, :null => false
    end
    add_index :electricity_accounts, [:user_id]
    add_index :electricity_accounts, [:electricity_supplier_id]

    # electricity reading table
    create_table :electricity_readings do |t|
      t.column :electricity_account_id, :integer, :limit => 10, :default => 0, :null => false
      t.column :kWh_day, :float, :default => 0.0, :null => false
      t.column :kWh_night, :float
      t.column :taken_on, :date, :null => false
    end
    add_index :electricity_readings, [:electricity_account_id]

    # electricity sources
    create_table :electricity_sources do |t|
      t.column :country_id, :integer, :limit => 10, :default => 0, :null => false
      t.column :source, :string, :default => "", :null => false
      t.column :g_per_kWh, :integer, :limit => 10, :default => 0
    end
    add_index :electricity_sources, [:country_id]

    # electricity suppliers
    create_table :electricity_suppliers do |t|
      t.column :country_id, :integer, :limit => 10, :default => 0, :null => false
      t.column :name, :string, :limit => 45
    end
    add_index :electricity_suppliers, [:country_id]

    # electricity sources/suppliers join table
    create_table :electricity_sources_electricity_suppliers do |t|
      t.column :electricity_source_id, :integer, :limit => 10, :default => 0, :null => false
      t.column :electricity_supplier_id, :integer, :limit => 10, :default => 0, :null => false
      t.column :percentage, :float, :default => 0.0, :null => false
    end
    add_index :electricity_sources_electricity_suppliers, [:electricity_supplier_id], :name => "elec_sources_suppliers_supplier_index"
    add_index :electricity_sources_electricity_suppliers, [:electricity_source_id], :name => "elec_sources_suppliers_source_index"

  end 

  def self.down
    drop_table :electricity_accounts
    drop_table :electricity_readings
    drop_table :electricity_sources
    drop_table :electricity_suppliers
    drop_table :electricity_sources_electricity_suppliers
  end

end
