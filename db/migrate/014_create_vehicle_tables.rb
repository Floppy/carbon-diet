class CreateVehicleTables < ActiveRecord::Migration

  def self.up

    # Create vehicle fuel types
    create_table :vehicle_fuel_types do |t|
      t.column :name, :string, :default => "", :null => false
      t.column :g_per_l, :integer, :limit => 10, :default => 0
      t.column :vehicle_fuel_class_id, :integer, :limit => 10, :default => 0, :null => false
    end
    add_index :vehicle_fuel_types, [:vehicle_fuel_class_id]

    # Create vehicle fuel classes
    create_table :vehicle_fuel_classes do |t|
      t.column :name, :string, :default => "", :null => false
      t.column :country_id, :integer, :limit => 10, :default => 0, :null => false
    end
    add_index :vehicle_fuel_classes, [:country_id]
 
    # Create vehicles themselves
    create_table :vehicles do |t|
      t.column :vehicle_fuel_class_id, :integer, :limit => 10, :default => 0, :null => false
      t.column :user_id, :integer, :limit => 10, :default => 0, :null => false
      t.column :active, :boolean, :default => true, :null => false
      t.column :name, :string, :default => "Car", :null => false
    end
    add_index :vehicles, [:user_id]
    add_index :vehicles, [:vehicle_fuel_class_id]

    # Create vehicle fuel purchases
    create_table :vehicle_fuel_purchases do |t|
      t.column :vehicle_id, :integer, :limit => 10, :default => 0, :null => false
      t.column :vehicle_fuel_type_id, :integer, :limit => 10, :default => 0, :null => false
      t.column :litres, :float, :default => 0.0, :null => false
      t.column :purchased_on, :date, :null => false
    end
    add_index :vehicle_fuel_purchases, [:vehicle_id]
    add_index :vehicle_fuel_purchases, [:vehicle_fuel_type_id]

  end

  def self.down
    drop_table :vehicle_fuel_types
    drop_table :vehicle_fuel_classes
    drop_table :vehicles
    drop_table :vehicle_fuel_purchases
  end
end
