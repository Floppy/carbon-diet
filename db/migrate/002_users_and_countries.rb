class UsersAndCountries < ActiveRecord::Migration

  def self.up
    # Countries table
    create_table :countries do |t|
      t.column :name, :string, :null => false
      t.column :abbreviation, :string, :null => false
    end
    
    # Users table
    create_table :users do |t|
      t.column :email, :string, :null => false
      t.column :password, :string, :null => false
      t.column :name, :string
      t.column :created_on, :date
      t.column :public, :boolean, :default => false, :null => false
      t.column :pester, :boolean, :default => false, :null => false
      t.column :country_id, :integer, :limit => 10, :null => false
      t.column :region_id, :integer, :limit => 10
    end

  end

  def self.down
    drop_table :users
    drop_table :countries
  end

end
