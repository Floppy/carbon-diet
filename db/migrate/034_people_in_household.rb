class PeopleInHousehold < ActiveRecord::Migration

  def self.up
    add_column :users, :people_in_household, :integer, :default => 1, :null => false
  end

  def self.down
    remove_column :users, :people_in_household
  end
    
end
