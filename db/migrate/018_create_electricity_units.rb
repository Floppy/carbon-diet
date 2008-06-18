class CreateElectricityUnits < ActiveRecord::Migration

  def self.up

    create_table :electricity_units do |t|
      t.column :name, :string, :default => "", :null => false
      t.column :abbreviation, :string, :default => "", :null => false
      t.column :amount_in_kWh, :float, :default => 0.0, :null => false
    end

    rename_column :electricity_readings, :kWh_day, :reading_day
    rename_column :electricity_readings, :kWh_night, :reading_night

    add_column :electricity_accounts, :electricity_unit_id, :integer, :limit => 10, :null => false, :default => 1

    ElectricityUnit.create(:name => 'Kilowatt-Hours', :abbreviation=>"kWh", :amount_in_kWh => "1")

  end

  def self.down
    drop_table :electricity_units
    remove_column :electricity_accounts, :electricity_unit_id
    rename_column :electricity_readings, :reading_day, :kWh_day
    rename_column :electricity_readings, :reading_night, :kWh_night
  end
end
