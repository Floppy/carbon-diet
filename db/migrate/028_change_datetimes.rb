class ChangeDatetimes < ActiveRecord::Migration

  def self.up
    # Completed actions
    change_column :completed_actions, "created_on", :datetime
    rename_column :completed_actions, "created_on", "created_at"
    # User reminder
    change_column :users, "reminded_on", :datetime
    rename_column :users, "reminded_on", "reminded_at"
  end
  
  def self.down
    # User reminder
    rename_column :users, "reminded_at", "reminded_on"
    change_column :users, "reminded_on", :date
    # Completed actions
    rename_column :completed_actions, "created_at", "created_on"
    change_column :completed_actions, "created_on", :date
  end

end
