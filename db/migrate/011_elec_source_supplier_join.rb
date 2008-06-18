class ElecSourceSupplierJoin < ActiveRecord::Migration

  def self.up

    drop_table :electricity_sources_electricity_suppliers

    # new electricity supplier/sources join table
    create_table :electricity_supplier_sources do |t|
      t.column :electricity_source_id, :integer, :limit => 10, :default => 0, :null => false
      t.column :electricity_supplier_id, :integer, :limit => 10, :default => 0, :null => false
      t.column :percentage, :float, :default => 0.0, :null => false
    end
    add_index :electricity_supplier_sources, [:electricity_supplier_id], :name => "elec_supplier_sources_supplier_index"
    add_index :electricity_supplier_sources, [:electricity_source_id], :name => "elec_supplier_sources_source_index"

  end 

  def self.down
    drop_table :electricity_supplier_sources

    # electricity sources/suppliers join table
    create_table :electricity_sources_electricity_suppliers do |t|
      t.column :electricity_source_id, :integer, :limit => 10, :default => 0, :null => false
      t.column :electricity_supplier_id, :integer, :limit => 10, :default => 0, :null => false
      t.column :percentage, :float, :default => 0.0, :null => false
    end
    add_index :electricity_sources_electricity_suppliers, [:electricity_supplier_id], :name => "elec_sources_suppliers_supplier_index"
    add_index :electricity_sources_electricity_suppliers, [:electricity_source_id], :name => "elec_sources_suppliers_source_index"

  end

end
