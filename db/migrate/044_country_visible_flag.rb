class CountryVisibleFlag < ActiveRecord::Migration

  def self.up
    add_column :countries, :visible, :boolean, :default => true
  end
  
  def self.down
    remove_column :countries, :visible
  end

end
