class ChangeDefaultReminderInterval < ActiveRecord::Migration
  def self.up
    change_column :users, "reminder_frequency", :integer,  :limit => 10, :default => 2, :null => false
  end

  def self.down
    change_column :users, "reminder_frequency", :integer,  :limit => 10, :default => 0, :null => false
  end
end
