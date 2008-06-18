class GasTables < ActiveRecord::Migration

  def self.up

    # gas account table
    create_table :gas_accounts do |t|
      t.column :gas_supplier_id, :integer, :limit => 10, :default => 0, :null => false
      t.column :user_id, :integer, :limit => 10, :default => 0, :null => false
      t.column :active, :boolean, :default => true, :null => false
      t.column :name, :string, :default => "Natural Gas", :null => false
    end
    add_index :gas_accounts, [:user_id]
    add_index :gas_accounts, [:gas_supplier_id]

    # gas reading table
    create_table :gas_readings do |t|
      t.column :gas_account_id, :integer, :limit => 10, :default => 0, :null => false
      t.column :m3, :float, :default => 0.0, :null => false
      t.column :taken_on, :date, :null => false
    end
    add_index :gas_readings, [:gas_account_id]

    # gas suppliers
    create_table :gas_suppliers do |t|
      t.column :country_id, :integer, :limit => 10, :default => 0, :null => false
      t.column :name, :string, :limit => 45
      t.column :g_per_m3, :integer, :limit => 10, :default => 0
    end
    add_index :gas_suppliers, [:country_id]

  end 

  def self.down
    drop_table :gas_accounts
    drop_table :gas_readings
    drop_table :gas_suppliers
  end

end
