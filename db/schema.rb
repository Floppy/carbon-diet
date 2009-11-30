# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090112223729) do

  create_table "action_categories", :force => true do |t|
    t.string "name",  :null => false
    t.string "image", :null => false
  end

  create_table "action_overrides", :force => true do |t|
    t.integer "action_id"
    t.text    "content",    :limit => 255,                    :null => false
    t.boolean "paid_for",                  :default => false, :null => false
    t.integer "country_id",                :default => 0,     :null => false
  end

  create_table "actions", :force => true do |t|
    t.string  "title",                                            :null => false
    t.text    "content",            :limit => 255,                :null => false
    t.string  "image"
    t.integer "action_category_id", :limit => 10,  :default => 1, :null => false
    t.integer "level",              :limit => 10,  :default => 1, :null => false
  end

  create_table "airports", :force => true do |t|
    t.string "icao_code", :null => false
    t.string "iata_code"
    t.string "name",      :null => false
    t.string "location",  :null => false
    t.string "country",   :null => false
    t.float  "latitude",  :null => false
    t.float  "longitude", :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.text     "text"
    t.integer  "commentable_id",   :null => false
    t.string   "commentable_type", :null => false
    t.datetime "created_at"
  end

  create_table "completed_actions", :force => true do |t|
    t.integer  "user_id",    :limit => 10, :default => 0, :null => false
    t.integer  "action_id",  :limit => 10, :default => 0, :null => false
    t.boolean  "done"
    t.datetime "created_at"
  end

  create_table "countries", :force => true do |t|
    t.string  "name",                                                     :null => false
    t.string  "abbreviation",                                             :null => false
    t.string  "flag_image"
    t.integer "vehicle_distance_unit_id", :limit => 10, :default => 1,    :null => false
    t.integer "vehicle_fuel_unit_id",     :limit => 10, :default => 1,    :null => false
    t.integer "electricity_unit_id",      :limit => 10, :default => 1,    :null => false
    t.integer "gas_unit_id",              :limit => 10, :default => 1,    :null => false
    t.boolean "visible",                                :default => true
  end

  create_table "electricity_accounts", :force => true do |t|
    t.integer "electricity_supplier_id", :limit => 10, :default => 0,             :null => false
    t.integer "user_id",                 :limit => 10, :default => 0,             :null => false
    t.boolean "night_rate",                            :default => false,         :null => false
    t.string  "name",                                  :default => "Electricity", :null => false
    t.boolean "current",                               :default => true,          :null => false
    t.integer "electricity_unit_id",     :limit => 10, :default => 1,             :null => false
    t.boolean "used_for_heating",                      :default => false,         :null => false
    t.boolean "used_for_water",                        :default => false,         :null => false
  end

  add_index "electricity_accounts", ["electricity_supplier_id"], :name => "index_electricity_accounts_on_electricity_supplier_id"
  add_index "electricity_accounts", ["user_id"], :name => "index_electricity_accounts_on_user_id"

  create_table "electricity_readings", :force => true do |t|
    t.integer "electricity_account_id", :limit => 10, :default => 0,     :null => false
    t.float   "reading_day",                          :default => 0.0,   :null => false
    t.float   "reading_night",                        :default => 0.0,   :null => false
    t.date    "taken_on",                                                :null => false
    t.boolean "automatic",                            :default => false
  end

  add_index "electricity_readings", ["electricity_account_id"], :name => "index_electricity_readings_on_electricity_account_id"

  create_table "electricity_sources", :force => true do |t|
    t.integer "country_id", :limit => 10, :default => 0,  :null => false
    t.string  "source",                   :default => "", :null => false
    t.integer "g_per_kWh",  :limit => 10, :default => 0
  end

  add_index "electricity_sources", ["country_id"], :name => "index_electricity_sources_on_country_id"

  create_table "electricity_supplier_sources", :force => true do |t|
    t.integer "electricity_source_id",   :limit => 10, :default => 0,   :null => false
    t.integer "electricity_supplier_id", :limit => 10, :default => 0,   :null => false
    t.float   "percentage",                            :default => 0.0, :null => false
  end

  add_index "electricity_supplier_sources", ["electricity_source_id"], :name => "elec_supplier_sources_source_index"
  add_index "electricity_supplier_sources", ["electricity_supplier_id"], :name => "elec_supplier_sources_supplier_index"

  create_table "electricity_suppliers", :force => true do |t|
    t.integer "country_id",  :limit => 10, :default => 0,     :null => false
    t.string  "name",        :limit => 45
    t.string  "company_url"
    t.string  "info_url"
    t.string  "aliases"
    t.boolean "default",                   :default => false
    t.integer "g_per_kWh"
  end

  add_index "electricity_suppliers", ["country_id"], :name => "index_electricity_suppliers_on_country_id"

  create_table "electricity_units", :force => true do |t|
    t.string "name",          :default => "",  :null => false
    t.string "abbreviation",  :default => "",  :null => false
    t.float  "amount_in_kWh", :default => 0.0, :null => false
  end

  create_table "flight_classes", :force => true do |t|
    t.string "name",         :null => false
    t.float  "scale_factor", :null => false
  end

  create_table "flight_factors", :force => true do |t|
    t.string  "name",        :null => false
    t.integer "lower_limit"
    t.integer "upper_limit"
    t.float   "g_per_km",    :null => false
  end

  create_table "flights", :force => true do |t|
    t.integer "user_id",                        :null => false
    t.integer "from_airport_id",                :null => false
    t.integer "to_airport_id",                  :null => false
    t.integer "passengers",      :default => 1, :null => false
    t.date    "outbound_on",                    :null => false
    t.date    "return_on"
    t.integer "flight_class_id", :default => 1, :null => false
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.boolean  "approved",   :default => false, :null => false
    t.datetime "created_at"
  end

  create_table "gas_accounts", :force => true do |t|
    t.integer "gas_supplier_id",  :limit => 10, :default => 0,             :null => false
    t.integer "user_id",          :limit => 10, :default => 0,             :null => false
    t.string  "name",                           :default => "Natural Gas", :null => false
    t.boolean "current",                        :default => true,          :null => false
    t.integer "gas_unit_id",      :limit => 10, :default => 1,             :null => false
    t.boolean "used_for_heating",               :default => true,          :null => false
    t.boolean "used_for_water",                 :default => true,          :null => false
  end

  add_index "gas_accounts", ["gas_supplier_id"], :name => "index_gas_accounts_on_gas_supplier_id"
  add_index "gas_accounts", ["user_id"], :name => "index_gas_accounts_on_user_id"

  create_table "gas_readings", :force => true do |t|
    t.integer "gas_account_id", :limit => 10, :default => 0,   :null => false
    t.float   "reading",                      :default => 0.0, :null => false
    t.date    "taken_on",                                      :null => false
  end

  add_index "gas_readings", ["gas_account_id"], :name => "index_gas_readings_on_gas_account_id"

  create_table "gas_suppliers", :force => true do |t|
    t.integer "country_id", :limit => 10, :default => 0,     :null => false
    t.string  "name",       :limit => 45
    t.integer "g_per_m3",   :limit => 10, :default => 0
    t.boolean "default",                  :default => false
  end

  add_index "gas_suppliers", ["country_id"], :name => "index_gas_suppliers_on_country_id"

  create_table "gas_units", :force => true do |t|
    t.string "name",         :default => "",  :null => false
    t.string "abbreviation", :default => "",  :null => false
    t.float  "amount_in_m3", :default => 0.0, :null => false
  end

  create_table "group_invitations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "inviter_id"
    t.datetime "created_at"
  end

  create_table "group_memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "description", :limit => 255
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "private",                    :default => false
  end

  create_table "notes", :force => true do |t|
    t.text     "note",           :null => false
    t.date     "date"
    t.integer  "notatable_id"
    t.string   "notatable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "display_name"
    t.datetime "created_at"
    t.boolean  "public",                                :default => false, :null => false
    t.integer  "country_id",              :limit => 10, :default => 0,     :null => false
    t.integer  "region_id",               :limit => 10
    t.boolean  "admin",                                 :default => false, :null => false
    t.string   "password_hash",                         :default => "",    :null => false
    t.string   "password_salt",                         :default => "",    :null => false
    t.string   "confirmation_code"
    t.boolean  "tester"
    t.integer  "reminder_frequency",      :limit => 10, :default => 2,     :null => false
    t.datetime "reminded_at"
    t.string   "login",                                 :default => "",    :null => false
    t.datetime "updated_at"
    t.string   "password_change_code"
    t.boolean  "notify_friend_requests",                :default => true
    t.integer  "people_in_household",                   :default => 1,     :null => false
    t.string   "login_key"
    t.datetime "login_key_expires_at"
    t.float    "annual_emission_total"
    t.boolean  "has_avatar",                            :default => false, :null => false
    t.datetime "last_login_at"
    t.string   "guid"
    t.boolean  "notify_profile_comments",               :default => true
  end

  create_table "vehicle_distance_units", :force => true do |t|
    t.string "name",         :default => "",  :null => false
    t.string "abbreviation", :default => "",  :null => false
    t.float  "amount_in_km", :default => 0.0, :null => false
  end

  create_table "vehicle_fuel_classes", :force => true do |t|
    t.string  "name",                     :default => "", :null => false
    t.integer "country_id", :limit => 10, :default => 0,  :null => false
  end

  add_index "vehicle_fuel_classes", ["country_id"], :name => "index_vehicle_fuel_classes_on_country_id"

  create_table "vehicle_fuel_purchases", :force => true do |t|
    t.integer "vehicle_id",           :limit => 10, :default => 0,   :null => false
    t.integer "vehicle_fuel_type_id", :limit => 10, :default => 0,   :null => false
    t.float   "amount",                             :default => 0.0, :null => false
    t.date    "purchased_on",                                        :null => false
    t.float   "distance"
  end

  add_index "vehicle_fuel_purchases", ["vehicle_fuel_type_id"], :name => "index_vehicle_fuel_purchases_on_vehicle_fuel_type_id"
  add_index "vehicle_fuel_purchases", ["vehicle_id"], :name => "index_vehicle_fuel_purchases_on_vehicle_id"

  create_table "vehicle_fuel_types", :force => true do |t|
    t.string  "name",                                :default => "",    :null => false
    t.integer "g_per_l",               :limit => 10, :default => 0
    t.integer "vehicle_fuel_class_id", :limit => 10, :default => 0,     :null => false
    t.boolean "default",                             :default => false
  end

  add_index "vehicle_fuel_types", ["vehicle_fuel_class_id"], :name => "index_vehicle_fuel_types_on_vehicle_fuel_class_id"

  create_table "vehicle_fuel_units", :force => true do |t|
    t.string "name",         :default => "",  :null => false
    t.string "abbreviation", :default => "",  :null => false
    t.float  "amount_in_l",  :default => 0.0, :null => false
  end

  create_table "vehicles", :force => true do |t|
    t.integer "vehicle_fuel_class_id",    :limit => 10, :default => 0,     :null => false
    t.integer "user_id",                  :limit => 10, :default => 0,     :null => false
    t.string  "name",                                   :default => "Car", :null => false
    t.boolean "current",                                :default => true,  :null => false
    t.integer "vehicle_fuel_unit_id",     :limit => 10, :default => 1,     :null => false
    t.integer "vehicle_distance_unit_id", :limit => 10, :default => 1,     :null => false
  end

  add_index "vehicles", ["user_id"], :name => "index_vehicles_on_user_id"
  add_index "vehicles", ["vehicle_fuel_class_id"], :name => "index_vehicles_on_vehicle_fuel_class_id"

end
