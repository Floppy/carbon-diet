class CreateFlights < ActiveRecord::Migration
  def self.up
    create_table :airports do |t|
      t.column :icao_code, :string, :length => 4, :null => false
      t.column :iata_code, :string, :length => 3
      t.column :name, :string, :null => false
      t.column :location, :string, :null => false
      t.column :country, :string, :null => false
      t.column :latitude, :float, :null => false
      t.column :longitude, :float, :null => false
    end
    create_table :flights do |t|
      t.column :user_id, :integer, :null => false
      t.column :from_airport_id, :integer, :null => false
      t.column :to_airport_id, :integer, :null => false
      t.column :passengers, :integer, :null => false, :default => 1
      t.column :outbound_on, :date, :null => false
      t.column :return_on, :date
    end
    ActionCategory.create(:name => "Air Travel", :image => 'plane.png')
  end

  def self.down
    drop_table :flights
    drop_table :airports
  end
end
