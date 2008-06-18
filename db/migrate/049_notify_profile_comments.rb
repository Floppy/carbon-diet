class NotifyProfileComments < ActiveRecord::Migration

  def self.up
    add_column :users, :notify_profile_comments, :boolean, :default => true
  end

  def self.down
    remove_column :users, :notify_profile_comments
  end
    
end
