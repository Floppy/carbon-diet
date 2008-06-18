class CreateFlightClasses < ActiveRecord::Migration
  def self.up
    # Create classes table
    create_table :flight_classes do |t|
      t.column :name, :string, :null => false
      t.column :scale_factor, :float, :null => false
    end
    # Create default classes
    FlightClass.create(:name => "Economy", :scale_factor => 1)
    FlightClass.create(:name => "Premium Economy", :scale_factor => 1.2)
    FlightClass.create(:name => "Business", :scale_factor => 2.1)
    FlightClass.create(:name => "First", :scale_factor => 3.4)
    # Add class id to flight
    add_column :flights, :flight_class_id, :integer, :null => false, :default => 1
  end

  def self.down
    remove_column :flights, :flight_class_id
    drop_table :flight_classes
  end
end
