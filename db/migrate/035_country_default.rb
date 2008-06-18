class CountryDefault < ActiveRecord::Migration

  def self.up
    change_column :users, :country_id, :integer,  :limit => 10, :default => 0, :null => false
  end

  def self.down
    change_column :users, :country_id, :integer,  :limit => 10, :null => false
  end
    
end
