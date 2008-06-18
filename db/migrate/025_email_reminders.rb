class EmailReminders < ActiveRecord::Migration

  def self.up
    remove_column :users, :pester
    add_column :users, :reminder_frequency, :integer, :limit => 10, :default => 0, :null => false
    add_column :users, :reminded_on, :date
  end

  def self.down
    add_column :users, :pester, :boolean, :default => false, :null => false
    remove_column :users, :reminder_frequency
    remove_column :users, :reminded_on
  end
    
end
