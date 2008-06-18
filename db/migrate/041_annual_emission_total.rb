class AnnualEmissionTotal < ActiveRecord::Migration
  def self.up
    add_column :users, :annual_emission_total, :float, :null => true
  end

  def self.down
    remove_column :users, :annual_emission_total
  end
end
