class EmailToLoginChange < ActiveRecord::Migration

  def self.up
    add_column :users, "login", :string, :default => "", :null => false
    change_column :users, "email", :string, :null => true
    change_column :users, "created_on", :datetime
    rename_column :users, "created_on", "created_at"
    add_column :users, "updated_at", :datetime
    rename_column :users, "name", "display_name"
    # Fix default password code bug from earlier migration
    remove_column :users, "password_change_code"
    add_column :users, "password_change_code", :string
  end

  def self.down
    remove_column :users, "login"
    change_column :users, "email", :string, :default => "", :null => false
    rename_column :users, "created_at", "created_on"
    change_column :users, "created_on", :date
    remove_column :users, "updated_at"
    rename_column :users, "display_name", "name"
  end
    
end
