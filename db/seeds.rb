u = User.new
u.login    = 'Admin'
u.password = 'admin'
u.save!

v = VehicleDistanceUnit.create :name         => "Kilometre",
                               :abbreviation => 'km',
                               :amount_in_km => 1.0

f = VehicleFuelUnit.create     :name         => "Litre",
                               :abbreviation => 'l',
                               :amount_in_l  => 1.0

g = GasUnit.create             :name         => "Cubic Metres",
                               :abbreviation => 'm3',
                               :amount_in_m3 => 1.0

e = ElectricityUnit.create     :name          => "Kilowatt-Hours",
                               :abbreviation  => 'kWh',
                               :amount_in_kWh => 1.0

c = Country.create             :name                     => 'United Kingdom',
                               :abbreviation             => 'UK',
                               :flag_image               => 'flags/gb.png',
                               :vehicle_distance_unit_id => v.id,
                               :vehicle_fuel_unit_id     => f.id,
                               :electricity_unit_id      => e.id,
                               :gas_unit_id              => g.id,
                               :visible                  => true

ElectricitySource.create       :country_id => c.id,
                               :g_per_kWh => 530,
                               :source => "Other"
ElectricitySource.create       :country_id => c.id,
                               :g_per_kWh => 890,
                               :source => "Coal"
ElectricitySource.create       :country_id => c.id,
                               :g_per_kWh => 360,
                               :source => "Gas"
ElectricitySource.create       :country_id => c.id,
                               :g_per_kWh => 0,
                               :source => "Nuclear"
ElectricitySource.create       :country_id => c.id,
                               :g_per_kWh => 0,
                               :source => "Renewable"

ElectricitySupplier.create     :country_id => c.id,
                               :name => "UK Standard",
                               :default => true,
                               :info_url => "www.electricityinfo.org/fuelmix.php"

