class NotifyFriendRequests < ActiveRecord::Migration

  def self.up
    add_column :users, :notify_friend_requests, :boolean, :default => true
  end

  def self.down
    remove_column :users, :notify_friend_requests
  end
    
end
