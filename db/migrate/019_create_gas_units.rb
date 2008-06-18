class CreateGasUnits < ActiveRecord::Migration

  def self.up

    create_table :gas_units do |t|
      t.column :name, :string, :default => "", :null => false
      t.column :abbreviation, :string, :default => "", :null => false
      t.column :amount_in_m3, :float, :default => 0.0, :null => false
    end

    rename_column :gas_readings, :m3, :reading

    add_column :gas_accounts, :gas_unit_id, :integer, :limit => 10, :null => false, :default => 1

    GasUnit.create(:name => 'Cubic Metres', :abbreviation=>"m3", :amount_in_m3 => "1")
    GasUnit.create(:name => 'Cubic Feet', :abbreviation=>"ft3", :amount_in_m3 => "0.0283168466")

  end

  def self.down
    drop_table :gas_units
    remove_column :gas_accounts, :gas_unit_id
    rename_column :gas_readings, :reading, :m3
  end
end
